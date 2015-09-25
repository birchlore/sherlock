require 'spec_helper'

describe Celebrity, :vcr do

  it { should belong_to(:shop) }

  it { should respond_to(:shop) }
  it { should respond_to (:first_name)}
  it { should respond_to (:last_name)}
  it { should respond_to (:email)}
  it { should respond_to (:imdb_url)}
  it { should respond_to (:wikipedia_url)}
  it { should respond_to (:twitter_followers)}
  it { should respond_to (:youtube_followers)}
  it { should respond_to (:instagram_followers)}
  it { should respond_to (:industry)}
  it { should respond_to (:imdb_bio)}
  it { should respond_to (:wikipedia_bio)}
  it { should respond_to (:status)}
  it { should respond_to (:shopify_url)}

  it { should validate_presence_of (:first_name)}
  it { should validate_presence_of (:last_name)}

  it { should respond_to (:celebrity?)}
  it { should respond_to (:celebrity_status)}
  it { should respond_to (:full_name)}
  it { should respond_to (:sanitize)}

  let(:shop) { FactoryGirl.create(:shop, twitter_follower_threshold: 1) }

  # Use build instead of create as celebrity validation will fail
  # on create and won't be able to create it in first place
  let(:celebrity) { FactoryGirl.build(:celebrity, shop: shop) }
  let(:twitter_celebrity) { FactoryGirl.create(:celebrity, shop: shop, twitter_followers: 2, email: "jacksondcunningham@gmail.com") }
  let(:imdb_celebrity) { FactoryGirl.create(:imdb_celebrity) }

  let(:wikipedia_celebrity) { FactoryGirl.create(:wikipedia_celebrity) }
  let(:wikipedia_dead_celebrity_string) {
   "Robert Lee Frost (March 26, 1874 – January 29, 1963) was an American poet. His work was initially published in England before it was published in America."
  }
  let(:wikipedia_alive_celebrity_string) {
   "Robert Lee Frost (March 26, 1974) was an American poet. His work was initially published in England before it was published in America."
  }

 let(:fullcontact_array_without_followers) {
  [{"type"=>"twitter",
  "typeId"=>"twitter",
  "typeName"=>"Twitter",
  "url"=>"https://twitter.com/zino0121",
  "username"=>"zino0121",
  "id"=>"1450305547"}]
 }

 let(:fullcontact_hash_without_type) {
  {"typeId"=>"twitter",
  "typeName"=>"Twitter",
  "url"=>"https://twitter.com/zino0121",
  "username"=>"zino0121",
  "id"=>"1450305547",
  "followers"=> 123
   }
 }

 let(:fullcontact_data_array) {
  [{"bio"=>"Change Agent at IBM Design",
  "type"=>"linkedin",
  "typeId"=>"linkedin",
  "typeName"=>"LinkedIn",
  "url"=>"https://www.linkedin.com/in/steveddaniels",
  "username"=>"steveddaniels"},
 {"type"=>"klout",
  "typeId"=>"klout",
  "typeName"=>"Klout",
  "url"=>"http://klout.com/steveddaniels",
  "username"=>"steveddaniels",
  "id"=>"32088152110190636"},
 {"followers"=>1343,
  "following"=>1343,
  "type"=>"facebook",
  "typeId"=>"facebook",
  "typeName"=>"Facebook",
  "url"=>"https://www.facebook.com/sleevedaniels",
  "username"=>"sleevedaniels",
  "id"=>"1385190060"},
 {"type"=>"vimeo",
  "typeId"=>"vimeo",
  "typeName"=>"Vimeo",
  "url"=>"http://vimeo.com/mkshftmag",
  "username"=>"mkshftmag",
  "id"=>"8360391"},
 {"bio"=>
   "Products with soul. Bringing design to value-based care at @ablehealth. Formerly @ibmdesign, @ibmresearch, @mkshftmag, @betterxdesign.",
  "followers"=>1770,
  "following"=>961,
  "type"=>"twitter",
  "typeId"=>"twitter",
  "typeName"=>"Twitter",
  "url"=>"https://twitter.com/steveddaniels",
  "username"=>"steveddaniels",
  "id"=>"19015299"},
 {"type"=>"googleprofile",
  "typeId"=>"googleprofile",
  "typeName"=>"Google Profile",
  "url"=>"https://plus.google.com/u/0/112334779745783722244",
  "id"=>"112334779745783722244"},
 {"type"=>"gravatar",
  "typeId"=>"gravatar",
  "typeName"=>"Gravatar",
  "url"=>"https://gravatar.com/ibmsocialcomp",
  "username"=>"ibmsocialcomp",
  "id"=>"18013099"},
 {"type"=>"quora",
  "typeId"=>"quora",
  "typeName"=>"Quora",
  "url"=>"http://www.quora.com/steve-daniels",
  "username"=>"steve-daniels"},
 {"type"=>"flickr",
  "typeId"=>"flickr",
  "typeName"=>"Flickr",
  "following"=>1343,
  "type"=>"facebook",
  "typeId"=>"facebook",
  "typeName"=>"Facebook",
  "url"=>"https://www.facebook.com/sleevedaniels",
  "username"=>"sleevedaniels",
  "id"=>"1385190060"},
 {"type"=>"vimeo",
  "typeId"=>"vimeo",
  "typeName"=>"Vimeo",
  "url"=>"http://vimeo.com/mkshftmag",
  "username"=>"mkshftmag",
  "id"=>"8360391"},
 {"bio"=>
   "Products with soul. Bringing design to value-based care at @ablehealth. Formerly @ibmdesign, @i
bmresearch, @mkshftmag, @betterxdesign.",
  "followers"=>1770,
  "following"=>961,
  "type"=>"twitter",
  "typeId"=>"twitter",
  "typeName"=>"Twitter",
  "url"=>"https://twitter.com/steveddaniels",
  "username"=>"steveddaniels",
  "id"=>"19015299"},
 {"type"=>"googleprofile",
  "typeId"=>"googleprofile",
  "typeName"=>"Google Profile",
  "url"=>"https://plus.google.com/u/0/112334779745783722244",
  "id"=>"112334779745783722244"},
 {"type"=>"gravatar",
  "typeId"=>"gravatar",
  "typeName"=>"Gravatar",
  "url"=>"https://gravatar.com/ibmsocialcomp",
  "username"=>"ibmsocialcomp",
  "id"=>"18013099"},
 {"type"=>"quora",
  "typeId"=>"quora",
  "typeName"=>"Quora",
  "url"=>"http://www.quora.com/steve-daniels",
  "username"=>"steve-daniels"},
 {"type"=>"flickr",
  "typeId"=>"flickr",
  "typeName"=>"Flickr",
  "url"=>"https://www.flickr.com/people/brownwib",
  "username"=>"brownwib",
  "id"=>"37359362@n07"},
 {"type"=>"foursquare",
  "typeId"=>"foursquare",
  "typeName"=>"Foursquare",
  "url"=>"https://foursquare.com/user/1593916",
  "id"=>"1593916"},
 {"followers"=>290,
  "following"=>353,
  "type"=>"pinterest",
  "typeId"=>"pinterest",
  "typeName"=>"Pinterest",
  "url"=>"http://www.pinterest.com/stevezie/",
  "username"=>"stevezie"},
 {"bio"=>
   "I use technology to promote making and creativity around the world, especially in environments of scarcity.",
  "type"=>"aboutme",
  "typeId"=>"aboutme",
  "typeName"=>"About.me",
  "url"=>"https://about.me/steveddaniels",
  "username"=>"steveddaniels"}]
 }

 let(:fullcontact_twitter_hash) {
  {"bio"=>
  "Products with soul. Bringing design to value-based care at @ablehealth. Formerly @ibmdesign, @ibmresearch, @mkshftmag, @betterxdesign.",
 "followers"=>1770,
 "following"=>961,
 "type"=>"twitter",
 "typeId"=>"twitter",
 "typeName"=>"Twitter",
 "url"=>"https://twitter.com/steveddaniels",
 "username"=>"steveddaniels",
 "id"=>"19015299"}
 }


let(:klout_profile_hash) {
  {
    kloutId: "27043",
    nick: "Ericbobmyers",
    score: {
      score: 63.05425156135237,
      bucket: "60-69"
    },
    scoreDeltas: {
      dayChange: 0.8801018966145193,
      weekChange: 5.259996562121209,
      monthChange: 3.6855222563244183
    }
  }
}

it "has a valid factory" do
  expect(celebrity).to_not be_valid
  expect(twitter_celebrity).to be_valid
  expect(wikipedia_celebrity).to be_valid
  expect(imdb_celebrity).to be_valid
end


it "returns a celebrity's full name as a string" do
  contact = FactoryGirl.build(:celebrity, first_name: "John", last_name: "Doe", email: "John@gmail.com")
  expect(contact.full_name).to eq("John Doe")
end


it "converts a celebrity's name to proper capitalization" do
  contact = FactoryGirl.create(:celebrity, first_name: "JoHN", last_name: "dOE", email: "John@gmail.com")
  expect(contact.full_name).to eq("John Doe")
end


describe 'is_dead?' do
  it "returns true for a dead celebrity" do
    expect(wikipedia_dead_celebrity_string.is_dead?).to be
  end

  it "returns false for an alive celebrity" do
    expect(wikipedia_alive_celebrity_string.is_dead?).not_to be
  end
end


describe "celebrity status" do

  context "has non ascii characters" do 
    it "will not call get_imdb" do 
      celebrity = FactoryGirl.build(:imdb_celebrity, first_name: "Sæthlangøy")
      expect(celebrity).not_to be_valid
    end
  end

  context "has a first name but not a last name" do
    it "returns nil" do
      expect_any_instance_of(Celebrity).to receive(:celebrity_status).and_return(nil)
      Celebrity.create(first_name: "Jackson")
    end
  end

  context "has a last name but not a first name" do
    it "returns nil" do
      expect_any_instance_of(Celebrity).to receive(:celebrity_status).and_return(nil)
      Celebrity.create(last_name: "Cunningham")
    end
  end

  context "does not have a first name or a last name" do
    it "returns nil" do
      expect_any_instance_of(Celebrity).to receive(:celebrity_status).and_return(nil)
      Celebrity.create()
    end
  end

end


describe 'celebrity?' do

  context 'customer has twitter followers above store threshold' do
    it 'determines whether or not the customer is a twitter celebrity' do
      expect(twitter_celebrity.celebrity?).to eq true
    end
  end

  context 'customer has celebrities below store threshold' do
    it 'determines whether or not the customer is a twitter celebrity' do
      expect(twitter_celebrity.celebrity?).to eq true
    end
  end

  context 'customer is imdb celebrity and imdb notifications turned on' do
    it 'determines whether or not the customer is an imdb celebrity' do
      expect(imdb_celebrity.celebrity?).to eq true
    end
  end

  context 'customer is imdb celebrity and imdb notifications turned off' do
    it 'determines whether or not the customer is an imdb celebrity' do
      expect(imdb_celebrity.celebrity?).to eq true
    end
  end

  context 'customer is wikipedia celebrity and wikipedia notifications turned on' do
    it 'determines whether or not the customer is a wikipedia celebrity' do
      expect(wikipedia_celebrity.celebrity?).to eq true
    end
  end

  context 'customer is wikipedia celebrity and wikipedia notifications turned off' do
    it 'determines whether or not the customer is a wikipedia celebrity' do
      expect(wikipedia_celebrity.celebrity?).to eq true
    end
  end

end

describe "get full_contact_data_array" do 
  it "returns a data array" do
   expect(twitter_celebrity.get_fullcontact_data_array).to be_an_instance_of(Array)
  end
end

describe 'send_email_notification' do

  context 'when email notifications are turned on and customer is a celebrity' do
    it 'should call send_email_notification on NotificationMailer' do
      expect(NotificationMailer).to receive(:celebrity_notification).with(an_instance_of(Celebrity)).and_return(double(deliver_now:true))
      FactoryGirl.create(:wikipedia_celebrity, shop: shop)
    end
  end

end

  describe 'get_fullcontact_profile_hash' do
    it "returns a hash of the desired social account" do 
      expect(celebrity.get_fullcontact_profile_hash(fullcontact_data_array, "twitter")).to eq(fullcontact_twitter_hash)
    end
  end





  describe "get_fullcontact_social_profile_data" do 

    context 'when social profile has no follower count present' do
      it 'does not change the Celebritys follower count to nil' do
        celebrity.get_fullcontact_social_profile_data(fullcontact_array_without_followers, "twitter", ["followers"])
        expect(celebrity.twitter_followers).not_to be nil
      end
    end

    context "for twitter account" do
      it "sets followers and url" do
        celebrity.get_fullcontact_social_profile_data(fullcontact_data_array, "twitter", ["followers", "url"])
        expect(celebrity.twitter_followers).to eq(1770)
        expect(celebrity.twitter_url).to eq("https://twitter.com/steveddaniels")
      end
    end

    context "for linkedin" do
      it "sets bio and url" do 
        celebrity.get_fullcontact_social_profile_data(fullcontact_data_array, "linkedin", ["bio", "url"])
        expect(celebrity.linkedin_url).to eq("https://www.linkedin.com/in/steveddaniels")
        expect(celebrity.linkedin_bio).to eq("Change Agent at IBM Design")
      end
    end

    context "for non-listed profile" do
      it "returns nil" do 
        expect(celebrity.get_fullcontact_social_profile_data(fullcontact_data_array, "angellist", ["bio", "url"])).to be nil
      end
    end

    context "for an array with a non-existent column" do
      it "sets the existing column" do 
        imdb_celebrity.get_fullcontact_social_profile_data(fullcontact_data_array, "linkedin", ["followers", "url"])
        expect(imdb_celebrity.changed?).to be true
        expect(imdb_celebrity.linkedin_url).to eq("https://www.linkedin.com/in/steveddaniels")
      end
    end

    context "for an array with only a non-existing column" do
      it "does not change the celebrity" do 
        imdb_celebrity.get_fullcontact_social_profile_data(fullcontact_data_array, "linkedin", ["followers"])
        expect(imdb_celebrity.changed?).to be false
      end
    end

  end


# describe "get_klout_id" do
#   it "gets the klout ID from full contact data" do
#     expect(celebrity.get_klout_id(fullcontact_klout_hash)).to eq(27043)
#   end
# end

# describe "get_klout_url" do
#   it "gets the klout url from Full Contact Data" do
#     expect(celebrity.get_klout_url(fullcontact_klout_hash)).to eq("http://klout.com/Ericbobmyers")
#   end
# end

# describe "get_klout_hash" do
#   it "gets the users klout hash from klout API" do
#     expect(celebrity.get_klout_score(27043)).to eq(klout_profile_hash)
#   end
# end

# describe "get_klout_score" do
#   it "gets the users klout score from their klout hash" do
#     expect(celebrity.get_klout_score(klout_profile_hash)).to eq(63.05425156135237)
#   end
# end


end