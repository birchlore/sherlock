class Youtube
  
  def initialize(customer)
    @customer = customer
    @social_data = @customer.fullcontact_data
    @hash ||= hash
  end

  def hash
    username = @customer.youtube_username
    return unless username
    source = "https://www.googleapis.com/youtube/v3/channels?part=statistics&forUsername=#{username}&key=#{Figaro.env.youtube_api_key}"
    json = GetJSON.call(source)
    json.try(:[], 'items').try(:first).try(:[], 'statistics')
  end

  def subscribers
    return unless @hash
    @subscribers ||= @hash.try(:[],'subscriberCount').try(:to_i)
  end

  def views
    return unless @hash
    @views ||= @hash.try(:[],'viewCount').try(:to_i)
  end


end