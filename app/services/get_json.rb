class GetJSON
   def self.call(source)
    uri = URI.parse(source)

    begin
  		res = Net::HTTP.get_response(uri)
	rescue Net::ReadTimeout => e
	  Rollbar.error e
	end

    return unless res.is_a?(Net::HTTPSuccess)
    JSON.parse(res.body)
  end
end