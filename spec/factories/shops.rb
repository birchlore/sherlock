FactoryGirl.define do
  factory :shop do
    sequence(:shopify_domain) { |n|
      "#{n}sherlocks-spears.myshopify.com"
    }
    shopify_token '12345'
    twitter_follower_threshold 1
    plan 'god'

    trait :actual_domain do
      shopify_domain "sherlocks-spears.myshopify.com"
    end

  end

   factory :imdb_shop, parent: :shop do
     imdb_notification true
   end

end
