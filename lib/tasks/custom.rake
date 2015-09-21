task :fullcontact_hits => :environment do
  @celebrities = []
  Celebrity.where("twitter_followers > ?", 1).each do |celebrity|
    @celebrities << celebrity.id
  end
  print @celebrities
end