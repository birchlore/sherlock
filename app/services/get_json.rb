class GetJSON < Services
   def self.call(source)
    uri = URI.parse(source)
    res = Net::HTTP.get_response(uri)
    return unless res.is_a?(Net::HTTPSuccess)
    JSON.parse(res.body)
  end
end