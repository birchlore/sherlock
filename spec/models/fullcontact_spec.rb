require 'spec_helper'
require 'shared_examples'

describe Fullcontact, :vcr do
  include_context "shared examples"


before(:all) do
  shop = build(:shop)
  super_celebrity = build(:super_celebrity, shop: shop)
  celebrity = build(:celebrity, shop: shop)
  @fullcontact = Fullcontact.new(super_celebrity)
  @fullcontact_dud = Fullcontact.new(celebrity)
end

  describe "data" do
    it "gets a fullcontact data array from a celebrity object" do
      expect(@fullcontact.data).to be_an_instance_of(Array)
    end
  end


  describe "profile_hash" do
    it "returns a hash of the desired social account" do 
      expect(@fullcontact.profile_hash("twitter")).to be_an_instance_of(Hash)
    end
  end


    describe "profile_data" do

      context 'when social profile has no follower count present' do
        it 'does not change the Celebritys follower count to nil' do
          expect(@fullcontact_dud.profile_data("followers")).to be nil
        end
      end

      context "when querying a twitter account" do
        it "gets a requested column value" do
          expect(@fullcontact.profile_data("followers")).to be_an_instance_of(Fixnum)
        end
      end

      context "when querying linkedin" do
        it "gets a requested column value" do 
          expect(@fullcontact.profile_data("bio")).to be_an_instance_of(String)
        end
      end

      context "when supplying an array with only a non-existing column" do
        it "does not change the celebrity" do 
          expect(@fullcontact.profile_data("crushes")).to be nil
        end
      end

      context "when looking for a klout id" do
        it "gets the klout ID from full contact data" do
          expect(@fullcontact.profile_data("id")).to be_an_instance_of(String)
        end
      end

      context "when looking for a klout url" do
        it "gets the klout url from Full Contact Data" do
          expect(@fullcontact.profile_data("url")).to be_an_instance_of(String)
        end
      end
    end




end

