require 'open-uri'
require 'json'
require 'pry'

class Celebrity < ActiveRecord::Base
  belongs_to :shop, :inverse_of => :celebrities

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :shop
  before_validation :sanitize

  validate :celebrity_status, :on => :create
  
  after_create :send_email_notification


  def celebrity_status
    return if errors.present?
    get_imdb
    get_wikipedia
    get_followers
    if !celebrity?
      self.errors.add(:body, "This ain't no celebrity, kid")
    end
  end

  def full_name
    first_name + " " + last_name
  end

  def celebrity?
    (imdb_url && self.shop.imdb_notification) || 
    (wikipedia_url && self.shop.wikipedia_notification) || 
    (followers > self.shop.twitter_follower_threshold)
  end

  def sanitize
    fields = ["first_name", "last_name"]
    fields.each do |field| 
      self[field] && self[field] = self[field].gsub(/\s+/, "").capitalize
    end
  end

  protected


  def get_imdb
    source = "http://www.imdb.com/xml/find?json=1&nr=1&nm=on&q="+ first_name + "+" + last_name
    data = open(source).read
    json = JSON.parse(data)

    if json["name_popular"].present?
      imdb_data = json["name_popular"][0]
    elsif json["name_exact"].present?
      imdb_data = json["name_exact"][0]
    end

    if imdb_data.present? && imdb_data["name"].upcase == self.full_name.upcase
      self.imdb_url = "http://www.imdb.com/name/" + imdb_data["id"]
      self.imdb_description = imdb_data["description"]
    end
  end

  def get_wikipedia
    source = "https://en.wikipedia.org/w/api.php?action=opensearch&search=" + first_name + "%20" + last_name + "&limit=1&namespace=0&format=json"
    data = open(source).read
    json = JSON.parse(data)

    if json[0].present? && json[0].upcase == self.full_name.upcase

      wikipedia_url = json[3].first
      description = json[2].first
      if description && description.is_common? || description && description.is_dead?
        wikipedia_url = nil
      elsif description && description.is_a_redirect?
        description = "This person has an AKA. See their Wikipedia page."
      end

      self.wikipedia_url = wikipedia_url
      self.wikipedia_description = description
      
    end

  end

  def get_followers

    return unless self.email.present?
    source = "https://api.fullcontact.com/v2/person.json?email=" + self.email + "&apiKey=" + ENV['full_contact_api_key']
    uri = URI.parse(source)
    res = Net::HTTP.get_response(uri)

    return unless res.is_a?(Net::HTTPSuccess)


    json = JSON.parse(res.body)

    return if json["message"] && json["message"].include?("Queued")

    profiles = json["socialProfiles"]
    twitter = profiles.select {|profile| profile["type"] == "twitter"}.first

    if twitter.present?
      self.followers = twitter["followers"]
    end

  end

  
  private

  def send_email_notification
    if celebrity? && self.shop.email_notifications
      NotificationMailer.celebrity_notification(self).deliver_now
    end
  end



end
