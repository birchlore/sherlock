FactoryGirl.define do
  factory :shop do
    shopify_domain "sherlocks-spears.myshopify.com"
    shopify_token '12345'
    twitter_follower_threshold 1
    imdb_notification true
  end

end
