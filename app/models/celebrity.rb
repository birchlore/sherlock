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
