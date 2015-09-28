class Youtube
  
  class << self

    def get_hash(celebrity)
      username = celebrity.youtube_username
      return unless username
      source = "https://www.googleapis.com/youtube/v3/channels?part=statistics&forUsername=#{username}&key=#{Figaro.env.youtube_api_key}"
      json = GetJSON.call(source)
      json.try(:[], 'items').try(:first).try(:[], 'statistics')
    end

    def get_subscribers(youtube_hash)
      youtube_hash.try(:[],'subscriberCount').try(:to_i)
    end

    def get_views(youtube_hash)
     youtube_hash.try(:[],'viewCount').try(:to_i)
    end

  end
end