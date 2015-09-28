require 'open-uri'
require 'json'
require 'pry'

class Celebrity < ActiveRecord::Base
  belongs_to :shop, :inverse_of => :celebrities

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :shop
  before_validation :sanitize

  validate :get_celebrity_status, :on => :create
  
  after_create :send_email_notification

  def full_name
    first_name + " " + last_name
  end
  
  def sanitize
    fields = ["first_name", "last_name"]
    fields.each do |field| 
      self[field] && self[field] = self[field].gsub(/\s+/, "").capitalize
    end
  end

  def celebrity?
    (imdb_url && shop.imdb_notification) || 
    (wikipedia_url && shop.wikipedia_notification) || 
    (twitter_followers && twitter_followers > shop.twitter_follower_threshold)
  end

  def set_social_data(social_data)
    self.twitter_followers = Fullcontact.get_profile_data(social_data, "twitter", "followers")
    self.twitter_url = Fullcontact.get_profile_data(social_data, "twitter", "url")
    
    self.linkedin_bio = Fullcontact.get_profile_data(social_data, "linkedin", "bio")
    self.linkedin_url = Fullcontact.get_profile_data(social_data, "linkedin","url")
    
    self.angellist_bio = Fullcontact.get_profile_data(social_data, "angellist", "bio")
    self.angellist_url = Fullcontact.get_profile_data(social_data, "angellist", "url")

    self.klout_id = Fullcontact.get_profile_data(social_data, "klout", "id")
    self.klout_url = Fullcontact.get_profile_data(social_data, "klout", "url")
    self.klout_score = Klout.get_score(self)

    self.instagram_id = Instagram.get_id(self)
    self.instagram_followers = Instagram.get_followers(self)

    self.youtube_url = Fullcontact.get_profile_data(social_data, "youtube", "url")
    self.youtube_username = Fullcontact.get_profile_data(social_data, "youtube", "username")
    
    youtube_hash = Youtube.get_hash(self)

    if youtube_hash
      self.youtube_subscribers = Youtube.get_subscribers(youtube_hash)
      self.youtube_views = Youtube.get_views(youtube_hash)
    end

  end

  private

  def get_celebrity_status
    GetCelebrityStatus.call(self)
  end


  def send_email_notification
    if self.shop.email_notifications
        NotificationMailer.celebrity_notification(self).deliver_now
    end
  end
end
