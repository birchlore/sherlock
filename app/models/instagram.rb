class Instagram
  def initialize(customer)
    @customer = customer
    @url = url
    @username = username
    @id ||= get_id
    @data ||= data
  end

  def url
    klout_url = @customer.klout_url
    return unless klout_url
    uri = HTTParty.get(klout_url)
    doc = Nokogiri::HTML(uri)
    ig = doc.at_css('.ig')
    return unless ig
    ig.at_css('a').attributes['href'].value
  end

  def username
    return unless url
    username = url.scan(/\/instagram.com\/(\w+)\//)
    return unless username
    username = username.first
    return unless username
    username.first
  end

  def get_id
    return unless @username
    source = "https://api.instagram.com/v1/users/search?q=#{@username}&client_id=#{Figaro.env.instagram_client_id}"
    json = GetJSON.call(source)
    json['data'].first['id']
  end

  def data
    return unless @id
    source = "https://api.instagram.com/v1/users/#{@id}/?client_id=#{Figaro.env.instagram_client_id}"
    GetJSON.call(source)
  end

  attr_reader :id

  def followers
    return unless @data
    @data.try(:[], 'data').try(:[], 'counts').try(:[], 'followed_by')
  end
end
