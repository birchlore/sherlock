Resque::Server.use(Rack::Auth::Basic) do |user, password|
  password == Figaro.env.resque_password
end