class Klout < Services

  class << self

    def get_hash(klout_id)
      source = "http://api.klout.com/v2/user.json/#{klout_id}?key=#{Figaro.env.klout_api_key}"
      json = GetJSON.call(source)
    end

    def get_score(klout_profile_hash)
      klout_profile_hash.try(:[],'score').try(:[], 'score')
    end

  end
end