require 'open-uri'
require 'json'
require 'pry'

class Celebrity < ActiveRecord::Base
  belongs_to :shop, :inverse_of => :celebrities
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :shop
  before_validation :sanitize
  after_validation :update_celebrity_stats
  before_save :celebrity?
  after_create :send_email_notification


  def full_name
    first_name + " " + last_name
  end

  def celebrity?
    (imdb_url && self.shop.imdb_notification) || (wikipedia_url && self.shop.wikipedia_notification) || (followers > self.shop.twitter_follower_threshold)
  end

  protected

  def send_email_notification
    if celebrity? && self.shop.email_notifications
      NotificationMailer.celebrity_notification(self).deliver_now
    end
  end

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

      description = json[2].first
      if description && description.include?("may refer to")
        description = "This is a common name and may refer to several celebrities."
      elsif description && description.include?("This is a redirect")
        description = "This person has an AKA. See their Wikipedia page."
      end

      self.wikipedia_description = description
      self.wikipedia_url = json[3].first
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

  def sanitize
    fields = ["first_name", "last_name", "email"]
    fields.each do |field| 
      if self[field]
        self[field].strip!
        self[field] = self[field].downcase.titleize
      end
    end
  end

  def update_celebrity_stats
    get_imdb
    get_wikipedia
    get_followers
  end

end
