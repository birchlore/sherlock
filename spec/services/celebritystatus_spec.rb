require 'spec_helper'
require 'shared_examples'

describe GetCelebrityStatus, :vcr do
  include_context "shared examples"


    describe "self.call" do

      context "when customers name has non ascii characters" do 
        it "will not call get_imdb" do 
          celebrity = build(:imdb_celebrity, first_name: "Sæthlangøy")
          expect(celebrity).not_to be_valid
        end
      end

      context "when customer has a first name but not a last name" do
        it "returns nil" do
          celebrity = build(:celebrity, last_name: nil)
          expect(GetCelebrityStatus.call(celebrity)).to be nil
        end
      end

      context "when customer has a last name but not a first name" do
        it "returns nil" do
          celebrity = build(:celebrity, first_name: nil)
          expect(GetCelebrityStatus.call(celebrity)).to be nil
        end
      end

      context "when customer does not have a first name or a last name" do
        it "returns nil" do
          celebrity = build(:celebrity, first_name: nil, last_name: nil)
          expect(GetCelebrityStatus.call(celebrity)).to be nil
        end
      end

      context "when customer is valid" do
        it "checks the different social channels for hits" do
          expect(GetIMDB).to receive(:call).with(celebrity)
          expect(GetWikipedia).to receive(:call).with(celebrity)
          expect(Fullcontact).to receive(:get_data_array).with(celebrity)
          celebrity.send(:get_celebrity_status)
        end

        it "saves the social data" do
          super_celebrity.shop.imdb_notification = true
          super_celebrity.send(:get_celebrity_status)
          expect(super_celebrity.imdb_url).to be
          expect(super_celebrity.imdb_bio).to be
          expect(super_celebrity.wikipedia_url).to be
          expect(super_celebrity.wikipedia_bio).to be
          expect(super_celebrity.twitter_url).to be
          expect(super_celebrity.twitter_followers).to be
          expect(super_celebrity.linkedin_url).to be
          expect(super_celebrity.linkedin_bio).to be
          expect(super_celebrity.angellist_url).to be
          expect(super_celebrity.angellist_bio).to be
          expect(super_celebrity.klout_url).to be
          expect(super_celebrity.klout_id).to be
        end
      end

    end



    describe "celebrity?" do

      context 'when customer has twitter followers above store threshold' do
        it 'returns true if customer is a twitter celebrity' do
          expect(twitter_celebrity.celebrity?).to be true
        end
      end

      context 'when customer has twitter followers below store threshold' do
        it 'returns false if customer is not a twitter celebrity' do
          no_twitter_celebrity = build(:celebrity, twitter_followers: 0)
          expect(no_twitter_celebrity.celebrity?).to be false
        end
      end

      context 'when customer is imdb celebrity and imdb notifications turned on' do
        it 'returns true if customer is an imdb celebrity' do
          expect(imdb_celebrity.celebrity?).to be true
        end
      end

      context 'when customer is imdb celebrity and imdb notifications turned off' do
        it 'returns false' do
          imdb_celebrity.shop.imdb_notification = false
          expect(imdb_celebrity.celebrity?).not_to be
        end
      end

      context 'when customer is wikipedia celebrity and wikipedia notifications turned on' do
        it 'returns true' do
          expect(wikipedia_celebrity.celebrity?).to be true
        end
      end

      context 'when customer is wikipedia celebrity and wikipedia notifications turned off' do
        it 'returns false' do
          wikipedia_celebrity.shop.wikipedia_notification = false
          expect(wikipedia_celebrity.celebrity?).not_to be
        end
      end

    end
end


