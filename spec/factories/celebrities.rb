require 'faker'

FactoryGirl.define do

  factory :celebrity do |f|
    association :shop
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.email { Faker::Internet.email }
  end

  factory :invalid_celebrity, parent: :celebrity do |f|
    f.firstname nil
  end

end