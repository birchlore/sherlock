if Rails.env.production? || Rails.env.staging?
	uri = URI.parse(Figaro.env.redis_to_go)
	REDIS = Redis.new(:url => uri)
end