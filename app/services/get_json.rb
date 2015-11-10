class GetJSON
   def self.call(source)

    begin
      uri = URI.parse(source)
    rescue URI::InvalidURIError => e
      Rollbar.error e
    end

    return unless uri

    begin
  		res = Net::HTTP.get_response(uri)
	  rescue Net::ReadTimeout => e
	    Rollbar.error e
      res = nil
	  end

    return unless res && res.is_a?(Net::HTTPSuccess)
    JSON.parse(res.body)
  end
end