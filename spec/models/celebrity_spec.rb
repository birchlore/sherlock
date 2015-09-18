require 'spec_helper'

describe Celebrity, :vcr do

  it { should belong_to(:shop) }


  it { should respond_to(:shop) }
  it { should respond_to (:first_name)}
  it { should respond_to (:last_name)}
  it { should respond_to (:email)}
  it { should respond_to (:imdb_url)}
  it { should respond_to (:wikipedia_url)}
  it { should respond_to (:followers)}
  it { should respond_to (:industry)}
  it { should respond_to (:imdb_description)}
  it { should respond_to (:wikipedia_description)}
  it { should respond_to (:status)}
  it { should respond_to (:shopify_url)}

  it { should respond_to (:celebrity?)}

  let(:shop) { FactoryGirl.build(:shop, twitter_follower_threshold: 1) }

  let(:twitter_celebrity) { FactoryGirl.build(:celebrity, shop: shop, followers: 2) }

  let(:wikipedia_response_dead_celebrity) {
    ["robert frost",
    ["Robert Frost"],
    ["Robert Lee Frost (March 26, 1874 – January 29, 1963) was an American poet. His work was initially published in England before it was published in America."],
    ["https://en.wikipedia.org/wiki/Robert_Frost"]]
  }

  describe 'celebrity?' do
    context 'twitter celebrity' do
      it 'should determine whether or not the customer is a celebrity' do
        expect(twitter_celebrity.celebrity?).to eq true
      end
    end
    context 'imdb celebrity' do
    end
    context 'imdb celebrity' do
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


  it "has a valid factory" do
    FactoryGirl.build(:shop)
    expect(FactoryGirl.build(:celebrity)).to_not be_valid
    expect(FactoryGirl.build(:twitter_celebrity)).to be_valid
    expect(FactoryGirl.build(:wikipedia_celebrity)).to be_valid
    expect(FactoryGirl.build(:imdb_celebrity, :shop=> FactoryGirl.build(:imdb_shop))).to be_valid
  end

  it "is invalid without a firstname" do
    expect(FactoryGirl.build(:celebrity, first_name: "")).to_not be_valid
  end

  it "is invalid without a lastname" do
    expect(FactoryGirl.build(:celebrity, last_name: "")).to_not be_valid
  end

  it "returns a celebrity's full name as a string" do
    contact = FactoryGirl.build(:celebrity, first_name: "John", last_name: "Doe", email: "John@gmail.com")
    expect(contact.full_name).to eq("John Doe")
  end

  it "converts a celebrity's name to proper capitalization" do
    contact = FactoryGirl.create(:celebrity, first_name: "JoHN", last_name: "dOE", email: "John@gmail.com")
    expect(contact.full_name).to eq("John Doe")
  end

  context "celebrity status" do

    let(:shop) {
      create(:shop, :imdb_notification => true)
    }

    it 'should work for imdb' do

      expect(FactoryGirl.create(:imdb_celebrity, :shop => shop)).to be_valid

    end

    

  end

end