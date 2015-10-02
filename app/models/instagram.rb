class Instagram

  def initialize(customer)
    @customer = customer
    @id ||= id
    @followers ||= followers
  end

   def id
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

  def followers
    return unless @id
    source = "https://api.instagram.com/v1/users/#{@id}/?client_id=#{Figaro.env.instagram_client_id}"
    json = GetJSON.call(source)
    json.try(:[], 'data').try(:[], 'counts').try(:[], 'followed_by')
    # json['data']['counts']['followed_by'] if json && json['data'] && json['data']['counts'] && json['data']['counts']['followed_by']
  end
  
end