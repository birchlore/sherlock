class RedisConnection
  def self.close
    connection.quit
  end

  def self.connection
    @connection ||= new_connection
  end

  def self.new_connection
    uri = URI.parse(ENV['REDISTOGO_URL'] || 'redis://localhost:6379/')

    Redis.new(host: uri.host,
              port: uri.port,
              password: uri.password,
              thread_safe: true)
  end
end
