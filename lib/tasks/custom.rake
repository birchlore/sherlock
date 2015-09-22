task :fullcontact_hits => :environment do
  @celebrities = []
  Celebrity.where("twitter_followers > ?", 1).each do |celebrity|
    @celebrities << celebrity.get_fullcontact_data
  end
  print @celebrities
end

