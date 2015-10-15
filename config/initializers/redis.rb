uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379/" )
Resque.redis = REDIS.connect(:url => uri)
