class Instagram

  def initialize(customer)
    @customer = customer
    @id ||= get_id
    @data ||= data
  end

   def get_id
    klout_url = @customer.klout_url
    return unless klout_url
    uri = HTTParty.get(klout_url)
    doc = Nokogiri::HTML(uri)
    ig = doc.at_css(".ig")
    return unless ig
    url = ig.at_css('a').attributes["href"].value
    return unless url
    url.scan(/\d+/).map(&:to_i).last
  end

  def id
    @id
  end

  def data
    return unless @id
    source = "https://api.instagram.com/v1/users/#{@id}/?client_id=#{Figaro.env.instagram_client_id}"
    GetJSON.call(source)
  end

  def followers
    return unless @data
    @data.try(:[], 'data').try(:[], 'counts').try(:[], 'followed_by')
  end

  def url
    return unless @data
    username = @data.try(:[], 'data').try(:[], 'username')
    "http://www.instagram.com/#{username}"
  end
  
end