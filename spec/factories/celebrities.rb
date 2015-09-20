require 'faker'

FactoryGirl.define do

  factory :celebrity do
    first_name { "Aaslkdfj" }
    last_name { "alfsijef" }
    email { "falwiejf@asldfij.com" }
    association :shop
  end

  factory :invalid_celebrity, parent: :celebrity do
    first_name nil
  end

  factory :twitter_celebrity, parent: :celebrity do
    email { "samantha@samanthaettus.com" }
  end

  factory :wikipedia_celebrity, parent: :celebrity do
    first_name { "Noah" }
    last_name { "Kagan" }
  end

  factory :imdb_celebrity, parent: :celebrity do
    first_name { "Jackson" }
    last_name { "Cunningham" }
    shop { build(:imdb_shop) }
  end

end