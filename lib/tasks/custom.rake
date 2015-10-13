task :set_missing_shopify_ids => :environment do
  Celebrity.where("shopify_id IS NULL").each do |celebrity|
  	url = celebrity.shopify_url
  	if url
	    celebrity.shopify_id = url.match(/customers\/\d+/)[0].match(/\d+/)[0].to_i
	    puts celebrity.full_name
	    celebrity.save
	end
  end

end


task :transfer_celebrities_to_customers => :environment do
	@customers = []
  Celebrity.all.each do |celebrity|
  	shop = Shop.find(celebrity.shop.id)

  	if celebrity.status = "archived"
  		archived = true 
  	else
  		archived = false
  	end

  	customer = shop.customers.new(
  				 status: "celebrity",
  				 archived: archived,
  				 first_name: celebrity.first_name,
  				 last_name: celebrity.last_name,
  				 email: celebrity.email,
  				 imdb_url: celebrity.imdb_url,
  				 wikipedia_url: celebrity.wikipedia_url,
  				 twitter_followers: celebrity.twitter_followers,
  				 imdb_bio: celebrity.imdb_bio,
  				 wikipedia_bio: celebrity.wikipedia_bio,
  				 shopify_url: celebrity.shopify_url,
  				 youtube_subscribers: celebrity.youtube_subscribers,
  				 instagram_followers: celebrity.instagram_followers,
  				 twitter_bio: celebrity.twitter_bio,
  				 twitter_url: celebrity.twitter_url,
  				 youtube_bio: celebrity.youtube_bio,
  				 youtube_url: celebrity.youtube_url,
  				 angellist_bio: celebrity.angellist_bio,
  				 angellist_url: celebrity.angellist_url,
  				 linkedin_bio: celebrity.linkedin_bio,
  				 linkedin_url: celebrity.linkedin_url,
  				 instagram_id: celebrity.instagram_id,
  				 klout_id: celebrity.klout_id,
  				 klout_score: celebrity.klout_score,
  				 klout_url: celebrity.klout_url,
  				 youtube_views: celebrity.youtube_views,
  				 youtube_username: celebrity.youtube_username,
  				 instagram_url: celebrity.instagram_url,
  				 shopify_id: celebrity.shopify_id
  				 )
	    @customers << customer.id
		customer.save
	end
	@customers
end

