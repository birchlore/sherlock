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
  it { should respond_to (:imdb_description)}
  it { should respond_to (:wikipedia_description)}
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

 let(:hash_without_followers) {
  {"type"=>"twitter",
  "typeId"=>"twitter",
  "typeName"=>"Twitter",
  "url"=>"https://twitter.com/zino0121",
  "username"=>"zino0121",
  "id"=>"1450305547"}
 }

 let(:hash_without_type) {
  {"typeId"=>"twitter",
  "typeName"=>"Twitter",
  "url"=>"https://twitter.com/zino0121",
  "username"=>"zino0121",
  "id"=>"1450305547",
  "followers"=> 123
   }
 }

 let(:social_data_array) {
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
 {"bio"=>
   "I build products that care for their users. I'm a Co-Founder at Able Health. I formerly led design for @ibm Watson Health and founded three social enterprises.",
  "followers"=>24,
  "following"=>0,
  "type"=>"angellist",
  "typeId"=>"angellist",
  "typeName"=>"AngelList",
  "url"=>"https://angel.co/steveddaniels",
  "username"=>"steveddaniels",
  "id"=>"1463720"},
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
 {"bio"=>
   "I build products that care for their users. I'm a Co-Founder at Able Health. I formerly led design for @ibm Watson Health and founded three social enterprises.",
  "followers"=>24,
  "following"=>0,
  "type"=>"angellist",
  "typeId"=>"angellist",
  "typeName"=>"AngelList",
  "url"=>"https://angel.co/steveddaniels",
  "username"=>"steveddaniels",
  "id"=>"1463720"},
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

 let(:twitter_profile_hash) {
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

 let(:linkedin_profile_hash) {
  {"bio"=>"Change Agent at IBM Design",
  "type"=>"linkedin",
  "typeId"=>"linkedin",
  "typeName"=>"LinkedIn",
  "url"=>"https://www.linkedin.com/in/steveddaniels",
  "username"=>"steveddaniels"}
}

 let(:angellist_profile_hash) {
  {"bio"=>
   "I build products that care for their users. I'm a Co-Founder at Able Health. I formerly led design for @ibm Watson Health and founded three social enterprises.",
  "followers"=>24,
  "following"=>0,
  "type"=>"angellist",
  "typeId"=>"angellist",
  "typeName"=>"AngelList",
  "url"=>"https://angel.co/steveddaniels",
  "username"=>"steveddaniels",
  "id"=>"1463720"}
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
  it "should return true for a dead celebrity" do
    expect(wikipedia_dead_celebrity_string.is_dead?).to be
  end

  it "should return false for an alive celebrity" do
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
    it "will return" do
      expect_any_instance_of(Celebrity).to receive(:celebrity_status).and_return(nil)
      Celebrity.create(first_name: "Jackson")
    end
  end

  context "has a last name but not a first name" do
    it "will return" do
      expect_any_instance_of(Celebrity).to receive(:celebrity_status).and_return(nil)
      Celebrity.create(last_name: "Cunningham")
    end
  end

  context "has does not have a first name or a last name" do
    it "will return" do
      expect_any_instance_of(Celebrity).to receive(:celebrity_status).and_return(nil)
      Celebrity.create()
    end
  end

end


describe 'celebrity?' do

  context 'twitter celebrity' do
    it 'should determine whether or not the customer is a twitter celebrity' do
      expect(twitter_celebrity.celebrity?).to eq true
    end
  end

  context 'imdb celebrity' do
    it 'should determine whether or not the customer is an imdb celebrity' do
      expect(imdb_celebrity.celebrity?).to eq true
    end
  end

  context 'wikipedia celebrity' do
    it 'should determine whether or not the customer is a wikipedia celebrity' do
      expect(wikipedia_celebrity.celebrity?).to eq true
    end
  end

end

describe "get full_contact_data_array" do 
  it "should return a data array" do
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

  describe 'get_social_hash' do
    it "should return a hash of the desired social account" do 
      expect(celebrity.get_social_hash(social_data_array, "twitter")).to eq(twitter_profile_hash)
    end
  end




  describe "get_followers" do 

    context 'when social profile has no follower count present' do
      it 'should not change the Celebritys follower count to nil' do
        celebrity.get_followers(hash_without_followers)
        expect(celebrity.twitter_followers).not_to be nil
      end
    end

    context "for twitter account" do
      it "should return the correct amount of followers" do
        expect(celebrity.get_followers(twitter_profile_hash)).to eq(1770)
      end
    end

  end




  describe "get_description" do 
    
    context "for twitter" do
      it "should return the correct description" do 
        expect(celebrity.get_description(twitter_profile_hash)).to eq("Products with soul. Bringing design to value-based care at @ablehealth. Formerly @ibmdesign, @ibmresearch, @mkshftmag, @betterxdesign.")
      end
    end

    context "for linkedin" do
      it "should return the correct description" do 
        expect(celebrity.get_description(linkedin_profile_hash)).to eq("Change Agent at IBM Design")
      end
    end

    context "for angel list" do
      it "should return the correct description" do 
        expect(celebrity.get_description(angellist_profile_hash)).to eq("I build products that care for their users. I'm a Co-Founder at Able Health. I formerly led design for @ibm Watson Health and founded three social enterprises.")
      end
    end

    context "with no type" do
      it "should return nil" do 
        expect(celebrity.get_description(hash_without_type)).to be nil
      end
    end

  end


end