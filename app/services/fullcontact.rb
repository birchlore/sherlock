class Fullcontact

  class << self 

    def get_data_array(celebrity)
      return unless celebrity.email.present?
      source = "https://api.fullcontact.com/v2/person.json?email=" + celebrity.email + "&apiKey=" + ENV['full_contact_api_key']
      json = GetJSON.call(source)
      return if !json || json["message"] && json["message"].include?("Queued")
      full_contact_data_array = json["socialProfiles"]
    end


    def get_profile_data(data_array, profile_name, column)
      profile_hash = get_profile_hash(data_array, profile_name)
      return unless profile_hash && profile_hash[column]
      profile_hash[column]
    end

    def get_profile_hash(full_contact_data_array, profile_name)
      full_contact_data_array.select {|profile| profile["type"] == profile_name}.first
    end

  end

end