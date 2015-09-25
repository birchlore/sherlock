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


  def celebrity?
    (imdb_url && self.shop.imdb_notification) || 
    (wikipedia_url && self.shop.wikipedia_notification) || 
    (twitter_followers > self.shop.twitter_follower_threshold)
  end


  def celebrity_status
    return unless first_name && last_name

    if full_name.ascii_only?
      get_imdb
      get_wikipedia
    end
    
    social_data = get_fullcontact_data_array
    
    if social_data
      get_fullcontact_social_profile_data(social_data, "twitter", ["followers", "url"])
      get_fullcontact_social_profile_data(social_data, "linkedin", ["bio", "url"])
      get_fullcontact_social_profile_data(social_data, "angellist", ["bio", "url"])
    end

    unless celebrity?
      self.errors.add(:body, "This ain't no celebrity, kid")
    end
  end


  def full_name
    first_name + " " + last_name
  end

  def get_fullcontact_data_array
    return unless self.email.present?
    source = "https://api.fullcontact.com/v2/person.json?email=" + self.email + "&apiKey=" + ENV['full_contact_api_key']
    
    json = get_json(source)

    return if !json || json["message"] && json["message"].include?("Queued")

    full_contact_data_array = json["socialProfiles"]
  end

  def get_fullcontact_profile_hash(full_contact_data_array, social_profile_name)
    full_contact_data_array.select {|profile| profile["type"] == social_profile_name}.first
  end


  def get_fullcontact_social_profile_data(fullcontact_data_array, social_profile_name, column_array)

    fullcontact_profile_hash = get_fullcontact_profile_hash(fullcontact_data_array, social_profile_name)
    
    return unless fullcontact_profile_hash

    column_array.each do |column|
      if fullcontact_profile_hash[column]
        self["#{social_profile_name}_#{column}"] = fullcontact_profile_hash[column] 
      end
    end

  end


  def get_klout_id(fullcontact_profile_hash)

  end

  def get_klout_url(fullcontact_profile_hash)
  end

  def get_klout_hash(klout_id)
  end

  def get_klout_score(klout_profile_hash)
  end


  def get_imdb
    source = "http://www.imdb.com/xml/find?json=1&nr=1&nm=on&q="+ first_name + "+" + last_name
    
    json = get_json(source)

    if json["name_popular"].present?
      imdb_data = json["name_popular"][0]
    elsif json["name_exact"].present?
      imdb_data = json["name_exact"][0]
    end

    if imdb_data.present? && imdb_data["name"].upcase == self.full_name.upcase
      self.imdb_url = "http://www.imdb.com/name/" + imdb_data["id"]
      self.imdb_bio = imdb_data["bio"]
    end
  end

   def get_instagram_followers(user_id)
    source = "https://api.instagram.com/v1/users/#{user_id}/?client_id=#{Figaro.env.instagram_client_id}"
    json = get_json(source)
    json["data"]["counts"]["followed_by"]
  end

  def get_json(source)
    uri = URI.parse(source)
    res = Net::HTTP.get_response(uri)
    return unless res.is_a?(Net::HTTPSuccess)
    JSON.parse(res.body)
  end


  def get_wikipedia
    source = "https://en.wikipedia.org/w/api.php?action=opensearch&search=" + first_name + "%20" + last_name + "&limit=1&namespace=0&format=json"
    
    json = get_json(source)

    if json[0].present? && json[0].upcase == self.full_name.upcase

      wikipedia_url = json[3].first
      bio = json[2].first
      if bio && bio.is_common? || bio && bio.is_dead?
        wikipedia_url = nil
      elsif bio && bio.is_a_redirect?
        bio = "This person has an AKA. See their Wikipedia page."
      end

      self.wikipedia_url = wikipedia_url
      self.wikipedia_bio = bio  
    end
  end


  def sanitize
    fields = ["first_name", "last_name"]
    fields.each do |field| 
      self[field] && self[field] = self[field].gsub(/\s+/, "").capitalize
    end
  end
  
  private

  def send_email_notification
    if self.shop.email_notifications
        NotificationMailer.celebrity_notification(self).deliver_now
    end
  end
end
