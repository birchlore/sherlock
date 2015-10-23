require 'open-uri'
require 'json'
require 'pry'

class Customer < ActiveRecord::Base
  belongs_to :shop
  
  before_validation :sanitize
  before_create :scans_depleted_notification
  validates_presence_of :shop, :on => :create

  def scan
    data = self.get_external_data
    return unless data
    self.get_celebrity_status

    if self.celebrity?
      self.shop.send_celebrity_notification(self) 
      self.status = "celebrity"
      self.save
    end
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
    first_name + " " + last_name
  end

  def set_social_data
    shop = self.shop
    set_twitter if shop.twitter_follower_threshold
    set_linkedin
    set_angellist
    set_klout if shop.klout_score_threshold
    set_instagram  if shop.twitter_follower_threshold
    set_youtube if shop.youtube_subscriber_threshold
  end

  def fullcontact_data
    @fullcontact ||= Fullcontact.new(self)
    fullcontact_data ||= @fullcontact.data
  end

  def get_external_data
    @wikipedia_data = wikipedia_data
    @imdb_data = imdb_data
    @fullcontact_data = fullcontact_data
    true if @wikipedia_data || @imdb_data || @fullcontact_data
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

   def get_celebrity_status
    set_imdb if @imdb_data && self.shop.imdb_notification
    set_wikipedia if @wikipedia_data && self.shop.wikipedia_notification
    set_social_data if @fullcontact_data
    # errors.add(:body, "This ain't no celebrity, kid") unless celebrity?
  end

  def sanitize
    self.first_name = self.first_name.sanitize_name if self.first_name.present?
    self.last_name = self.last_name.sanitize_name if self.last_name.present?
    self.email = self.email.sanitize_email if self.email.present?
  end

  private

  def scans_depleted_notification
    shop = self.shop
    NotificationMailer.scans_depleted(shop).deliver_now if shop.scans_remaining == 1
  end

	
end
