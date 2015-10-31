require 'open-uri'
require 'json'
require 'pry'

class Customer < ActiveRecord::Base
  belongs_to :shop
  
  before_validation :sanitize
  before_create :scans_depleted_notification
  validates_presence_of :shop, :on => :create

  def scan
    self.sanitize
    data = self.get_external_data
    return unless data
    self.get_celebrity_status

    if self.celebrity?
      self.shop.send_celebrity_notification(self) 
      self.status = "celebrity"
    end

    self.save
    
  end


  def teaser_scan
    return if self.shop.teaser_celebrity
    data = fullcontact_data
    return unless data

    set_social_data

    if self.teaser_celebrity?
      self.shop.teaser_celebrity = true
      self.shop.save
      NotificationMailer.teaser(self).deliver_now
    end
  end


  def get_external_data
    @wikipedia_data = wikipedia_data
    @imdb_data = imdb_data
    @fullcontact_data = fullcontact_data if self.shop.social_scans_remaining > 0
    true if @wikipedia_data || @imdb_data || @fullcontact_data
  end


  def get_celebrity_status
    set_imdb if @imdb_data
    set_wikipedia if @wikipedia_data
    set_social_data if @fullcontact_data
  end


  def celebrity?
    imdb_celebrity? || 
    wikipedia_celebrity? || 
    twitter_celebrity? || 
    instagram_celebrity? || 
    youtube_celebrity? || 
    klout_celebrity?
  end

  def shopify_url
    shop.shopify_domain + "/admin/customers/" + self.shopify_id.to_s
  end


  def full_name
    first_name + " " + last_name if first_name.present? && last_name.present?
  end

  def set_social_data
    set_twitter
    set_linkedin
    set_angellist
    set_klout
    set_instagram
    set_youtube
  end

  def fullcontact_data
    @fullcontact ||= Fullcontact.new(self)
    self.scanned_on_social = true
    fullcontact_data ||= @fullcontact.data
  end


  def imdb_celebrity?
    imdb_url && shop.imdb_notification
  end

  def wikipedia_celebrity?
    wikipedia_url && shop.wikipedia_notification
  end

  def youtube_celebrity?
    youtube_subscribers && youtube_subscribers > shop.youtube_subscriber_threshold
  end

  def instagram_celebrity?
    instagram_followers && instagram_followers > shop.instagram_follower_threshold
  end

  def klout_celebrity?
    klout_score && klout_score > shop.klout_score_threshold
  end

  def twitter_celebrity?
    twitter_followers && twitter_followers > shop.twitter_follower_threshold
  end

  def imdb_data
    return unless first_name.present? && last_name.present? && full_name.ascii_only?
    @imdb ||= IMDB.new(self)
    data ||= @imdb.data
  end

  def wikipedia_data
    return unless first_name.present? && last_name.present? && full_name.ascii_only?
    @wikipedia ||= Wikipedia.new(self)
    data = @wikipedia.data 
  end

  def self.search(search, page)
    paginate :per_page => 10, :page => page,
           :conditions => ['name like ?', "%#{search}%"],
           :order => 'name'
  end

  def duplicate?
   true if self.shop.customers.where(shopify_id: self.shopify_id).first || self.shop.celebrities.where(shopify_id: self.shopify_id).first
  end

  def teaser_celebrity?
    true if twitter_followers && twitter_followers > 5000 || youtube_subscribers && youtube_subscribers > 5000 || instagram_followers && instagram_followers > 5000
  end


  ## analytics data

  def self.percentage_with_imdb_match
    @count ||= Customer.count.to_f
    imdb_count = self.where("imdb_url IS NOT NULL").count
    (imdb_count).percent_of(@count)
  end

  def self.percentage_with_wikipedia_match
    @count ||= Customer.count
    wikipedia_count = self.where("wikipedia_url IS NOT NULL").count
    (wikipedia_count).percent_of(@count)
  end

  def self.percentage_with_followers(num_followers)
    @count ||= Customer.where(scanned_on_social: true).count
    twitter_followers = self.where("twitter_followers > ?", num_followers).count
    instagram_followers = self.where("instagram_followers > ?", num_followers).count
    youtube_subscribers = self.where("youtube_subscribers > ?", num_followers).count
    followers_count = twitter_followers + instagram_followers + youtube_subscribers
    (followers_count).percent_of(@count)
  end

  def self.percentage_with_klout_score(score)
    @count ||= Customer.where(scanned_on_social: true).count
    klout_count = self.where("klout_score > ?", score).count
    (klout_count).percent_of(@count)
  end

#e.g.  Customer.scans_until_match("followers", {followers:50000})  --> 1200

  def self.scans_until_match(match_type, options = {score: 0, followers: 0})
    score = options[:score]
    num_followers = options[:followers]

    if match_type == "imdb"
      (100 / self.percentage_with_imdb_match).ceil
    elsif match_type == "wikipedia"
      (100 / self.percentage_with_wikipedia_match).ceil
    elsif match_type == "klout"
      (100 / self.percentage_with_klout_score(score)).ceil
    elsif match_type == "followers"
      (100 / self.percentage_with_followers(num_followers)).ceil
    end
  end


  protected

  def set_wikipedia
    self.wikipedia_url = @wikipedia.url
    self.wikipedia_bio = @wikipedia.bio
  end

  def set_imdb
    self.imdb_url = @imdb.url
    self.imdb_bio = @imdb.bio
  end

  def set_angellist
    angellist_profile = @fullcontact.profile_hash("angellist")
    self.angellist_bio= @fullcontact.profile_data("bio")
    self.angellist_url = @fullcontact.profile_data("url")
  end

  def set_instagram
    instagram = Instagram.new(self)
    self.instagram_id = instagram.id
    self.instagram_followers = instagram.followers
    self.instagram_url = instagram.url
  end

  def set_klout
    klout_profile = @fullcontact.profile_hash("klout")
    self.klout_id = @fullcontact.profile_data("id")
    self.klout_url = @fullcontact.profile_data("url")
    klout = Klout.new(self)
    self.klout_score = klout.score
  end

   def set_linkedin
    linkedin_profile = @fullcontact.profile_hash("linkedin")
    self.linkedin_bio= @fullcontact.profile_data("bio")
    self.linkedin_url = @fullcontact.profile_data("url")
  end

   def set_twitter
    twitter_profile = @fullcontact.profile_hash("twitter")
    self.twitter_followers = @fullcontact.profile_data("followers")
    self.twitter_url = @fullcontact.profile_data("url")
    self.twitter_bio = @fullcontact.profile_data("bio")
  end

  def set_youtube
    youtube_profile = @fullcontact.profile_hash("youtube")
    self.youtube_url = @fullcontact.profile_data("url")
    self.youtube_username = @fullcontact.profile_data("username")
    youtube = Youtube.new(self)

    self.youtube_subscribers = youtube.subscribers
    self.youtube_views = youtube.views

  end

  def sanitize
    self.first_name = self.first_name.sanitize_name if self.first_name.present?
    self.last_name = self.last_name.sanitize_name if self.last_name.present?
    self.email = self.email.sanitize_email if self.email.present?
  end

  private

  def scans_depleted_notification
    shop = self.shop
    NotificationMailer.scans_depleted(shop).deliver_now if shop.social_scans_remaining == 1
  end

	
end
