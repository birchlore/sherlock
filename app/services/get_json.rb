class GetJSON
   def self.call(source)
   	encoded_url = URI.encode(source)
    uri = URI.parse(encoded_url)
    res = Net::HTTP.get_response(uri)
    return unless res.is_a?(Net::HTTPSuccess)
    JSON.parse(res.body)
  end
end