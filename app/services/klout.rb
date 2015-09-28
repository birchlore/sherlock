class Klout
  
  class << self

    def get_hash(celebrity)
      klout_id = celebrity.klout_id
      return unless klout_id
      source = "http://api.klout.com/v2/user.json/#{klout_id}?key=#{Figaro.env.klout_api_key}"
      json = GetJSON.call(source)
    end

    def get_score(celebrity)
      klout_profile_hash = get_hash(celebrity)
      return unless klout_profile_hash
      klout_profile_hash.try(:[],'score').try(:[], 'score')
    end

  end
end