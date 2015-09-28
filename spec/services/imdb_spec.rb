require 'spec_helper'
require 'shared_examples'


describe GetIMDB, :vcr do
  include_context "shared examples"

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



