require 'open-uri'
require 'open-uri'
require 'json'
require 'pry'

class Celebrity < ActiveRecord::Base
  belongs_to :shop, :inverse_of => :celebrities
  cattr_reader :users_processed

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :shop
  before_validation :sanitize
  before_validation :get_external_data

  validate :get_celebrity_status, :on => :create
  
  after_create :send_email_notification


  def celebrity?
    (imdb_url && shop.imdb_notification) || 
    (wikipedia_url && shop.wikipedia_notification) || 
    (twitter_followers && twitter_followers > shop.twitter_follower_threshold)
  end

  def full_name
    first_name + " " + last_name
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
    fullcontact_data ||= @fullcontact.data
  end

  def get_external_data
    wikipedia_data
    imdb_data
    fullcontact_data
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

  
  def get_celebrity_status
    set_imdb if imdb_data
    set_wikipedia if wikipedia_data
    set_social_data if fullcontact_data
    errors.add(:body, "This ain't no celebrity, kid") unless celebrity?
  end

  def sanitize
    fields = ["first_name", "last_name"]
    fields.each do |field| 
      self[field] && self[field] = self[field].gsub(/\s+/, "").capitalize
    end
  end

  def send_email_notification
    if self.shop.email_notifications
        NotificationMailer.celebrity_notification(self).deliver_now
    end
  end
end
