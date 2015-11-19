Resque::Server.use(Rack::Auth::Basic) do |_user, password|
  password == Figaro.env.resque_password
end