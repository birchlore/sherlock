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
  let(:twitter_celebrity) { FactoryGirl.create(:celebrity, shop: shop, twitter_followers: 2) }
  let(:imdb_celebrity) { FactoryGirl.create(:imdb_celebrity) }

  let(:wikipedia_celebrity) { FactoryGirl.create(:wikipedia_celebrity) }
  let(:wikipedia_dead_celebrity_string) {
   "Robert Lee Frost (March 26, 1874 – January 29, 1963) was an American poet. His work was initially published in England before it was published in America."
  }
  let(:wikipedia_alive_celebrity_string) {
   "Robert Lee Frost (March 26, 1974) was an American poet. His work was initially published in England before it was published in America."
  }

 let(:social_profiles_without_twitter_count) {
  [{"type"=>"twitter",
  "typeId"=>"twitter",
  "typeName"=>"Twitter",
  "url"=>"https://twitter.com/zino0121",
  "username"=>"zino0121",
  "id"=>"1450305547"},
 {"type"=>"klout",
  "typeId"=>"klout",
  "typeName"=>"Klout",
  "url"=>"http://klout.com/Zino0121",
  "username"=>"Zino0121",
  "id"=>"62768934473963200"}]
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
  context "has a first name and a last name" do
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

  describe 'send_email_notification' do

    context 'when email notifications are turned on and customer is a celebrity' do
      it 'should call send_email_notification on NotificationMailer' do
        expect(NotificationMailer).to receive(:celebrity_notification).with(an_instance_of(Celebrity)).and_return(double(deliver_now:true))
        FactoryGirl.create(:wikipedia_celebrity, shop: shop)
      end
    end

  end

  describe 'get_followers' do

    context 'when social profile has no follower count present' do
      it 'should not change the Celebritys follower count to nil' do
        celebrity.get_followers(social_profiles_without_twitter_count, "twitter")
        expect(celebrity.twitter_followers).to_not be nil
      end
    end


  end


end