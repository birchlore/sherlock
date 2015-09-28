require 'spec_helper'
require 'shared_examples'

describe Services, :vcr do
  include_context "shared examples"

    describe Fullcontact, :vcr do


      describe "get_data_array" do

        it "gets a fullcontact data array from a celebrity object" do
          expect(Fullcontact.get_data_array(twitter_celebrity)).to be_an_instance_of(Array)
        end

      end

      describe "get_profile_data" do

        context 'when social profile has no follower count present' do
          it 'does not change the Celebritys follower count to nil' do
            expect(Fullcontact.get_profile_data(fullcontact_array_without_followers, "twitter", "followers")).to be nil
          end
        end

        context "when querying a twitter account" do
          it "gets a requested column value" do
            expect(Fullcontact.get_profile_data(fullcontact_data_array, "twitter", "followers")).to eq(1770)
          end
        end

        context "when querying linkedin" do
          it "gets a requested column value" do 
            expect(Fullcontact.get_profile_data(fullcontact_data_array, "linkedin", "bio")).to eq("Change Agent at IBM Design")
          end
        end

        context "when querying a non-listed profile" do
          it "returns nil" do 
            expect(Fullcontact.get_profile_data(fullcontact_data_array, "snapchat", "bio")).to be nil
          end
        end

        context "when supplyinh an array with only a non-existing column" do
          it "does not change the celebrity" do 
            expect(Fullcontact.get_profile_data(fullcontact_data_array, "linkedin", "followers")).to be nil
          end
        end

        context "when looking for a klout id" do
          it "gets the klout ID from full contact data" do
            expect(Fullcontact.get_profile_data(fullcontact_data_array, "klout", "id")).to eq("32088152110190636")
          end
        end

        context "when looking for a klout url" do
          it "gets the klout url from Full Contact Data" do
            expect(Fullcontact.get_profile_data(fullcontact_data_array, "klout", "url")).to eq("http://klout.com/steveddaniels")
          end
        end

      end

      describe "get_profile_hash" do
        it "returns a hash of the desired social account" do 
          expect(Fullcontact.get_profile_hash(fullcontact_data_array, "twitter")).to eq(fullcontact_twitter_hash)
        end
      end



    end



    describe GetCelebrityStatus, :vcr do


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


    describe GetIMDB, :vcr do
        describe "call" do

            context "when customer is and imdb celebrity" do
                it "gets a customer's IMDB data" do
                    expect(GetIMDB.call(imdb_celebrity)).to eq(imdb_data)
                end
            end

            context "when customer is not an imdb celebrity" do
                it "returns nil" do
                    expect(GetIMDB.call(twitter_celebrity)).to be nil
                end
            end

        end
    end

    describe Instagram.get_followers, :vcr do

        describe "call" do
            context "when customer is an Instagram Celebrity" do
                it "gets a customer's Instagram follower count" do
                    expect(Instagram.get_followers.call(instagram_celebrity)).to be_an(Integer)
                end
            end

            context "when customer is not an Instagram Celebrity" do
                it "returns nil" do
                    expect(Instagram.get_followers.call(twitter_celebrity)).to be nil
                end
            end
        end
    end

    describe GetJSON, :vcr do

        describe "call" do
            context "when URI has valid JSON response" do
                it "gets a JSON hash from a URI" do
                    expect(GetJSON.call(json_uri)).to be
                end
            end

            context "when URI has no valid JSON response" do
                it "returns nil" do
                    expect(GetJSON.call(invalid_page)).not_to be
                end
            end
        end

    end

    describe GetWikipedia, :vcr do

        describe "call" do
            context "when customer has a wikipedia page" do
                it "returns a customer's Wikipedia data" do
                    expect(GetWikipedia.call(wikipedia_celebrity)).to be_an_instance_of(Hash)
                end
            end

            context "when customer does not have a wikipedia page" do
                it "returns nil" do
                    expect(GetWikipedia.call(celebrity)).not_to be
                end
            end
        end

    end


    describe Klout, :vcr do

        describe "get_hash" do
          it "gets the users klout hash from klout API" do
            expect(Klout.get_hash(27043)).to eq(klout_api_hash)
          end
        end

        describe "get_score" do
          it "gets the users klout score from their klout hash" do
            expect(Klout.get_score(klout_api_hash)).to eq(63.05425156135237)
          end
        end

    end

end

