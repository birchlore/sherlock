require 'spec_helper'
require 'shared_examples'

describe Fullcontact, :vcr do
  include_context "shared examples"


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

