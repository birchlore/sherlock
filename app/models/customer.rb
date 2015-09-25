require 'open-uri'
require 'json'
require 'pry'

class Customer < ActiveRecord::Base
  belongs_to :shop, :inverse_of => :customers
  after_initialize :celebrity_status

  def celebrity_status
    return unless first_name && last_name
    sanitize

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

    if celebrity?
      binding.pry
      Celebrity.create()
    else
      self.errors.add(:body, "This ain't no celebrity, kid")
    end
  end


  def celebrity?
    (imdb_url && self.shop.imdb_notification) || 
    (wikipedia_url && self.shop.wikipedia_notification) || 
    (twitter_followers > self.shop.twitter_follower_threshold)
  end

  protected

  def sanitize
    fields = ["first_name", "last_name"]
    fields.each do |field| 
      self[field] && self[field] = self[field].gsub(/\s+/, "").capitalize
    end
  end
  

end
