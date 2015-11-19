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
