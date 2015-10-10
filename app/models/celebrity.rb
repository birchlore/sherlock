require 'open-uri'
require 'json'
require 'pry'

class Celebrity < ActiveRecord::Base
  belongs_to :shop, :inverse_of => :celebrities

  validates_presence_of :first_name, :on => :create
  validates_presence_of :last_name, :on => :create
  validates_presence_of :shop, :on => :create
  validates :shopify_id, uniqueness: true, if: 'shopify_id.present?', :on => :create
  before_validation :sanitize, :on => :create
  before_validation :check_scans_remaining, :on => :create
  before_validation :get_external_data, :on => :create
  before_validation :get_celebrity_status, :on => :create
  after_create :increase_customers_processed_count
  after_create :send_email_notification


  def celebrity?
    imdb_celebrity? || 
    wikipedia_celebrity? || 
    twitter_celebrity? || 
    instagram_celebrity? || 
    youtube_celebrity? || 
    klout_celebrity?
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
    wikipedia_data
    imdb_data
    fullcontact_data
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
    return unless first_name && last_name && full_name.ascii_only?
    @imdb ||= IMDB.new(self)
    data ||= @imdb.data
  end

  def wikipedia_data
    return unless first_name && last_name && full_name.ascii_only?
    @wikipedia ||= Wikipedia.new(self)
    data ||= @wikipedia.data 
  end

  def self.search(search, page)
  paginate :per_page => 10, :page => page,
           :conditions => ['name like ?', "%#{search}%"],
           :order => 'name'
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


  private

   def check_scans_remaining
     return false unless shop && shop.scans_remaining > 0
   end

  
  def get_celebrity_status
    set_imdb if imdb_data && self.shop.imdb_notification
    set_wikipedia if wikipedia_data && self.shop.wikipedia_notification
    set_social_data if fullcontact_data
    errors.add(:body, "This ain't no celebrity, kid") unless celebrity?
  end

  def sanitize
    return unless first_name && last_name
    fields = ["first_name", "last_name"]
    fields.each do |field| 
      self[field] && self[field] = self[field].gsub(/\s+/, "").capitalize
    end
  end

  def increase_customers_processed_count
    date = Date.today
    record = self.shop.customer_records.where('date > ?', 30.days.ago).first_or_create(date: date)
    record.increase_count
  end

  def send_email_notification
    if self.shop.email_notifications
        NotificationMailer.celebrity_notification(self).deliver_now
    end
  end
end
