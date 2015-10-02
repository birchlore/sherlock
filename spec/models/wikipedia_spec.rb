require 'spec_helper'
require 'shared_examples'



describe Wikipedia, :vcr do
    include_context "shared examples"

    before(:all) do
        shop = build(:shop)
        wikipedia_celebrity = build(:wikipedia_celebrity, shop: shop)
        regular_customer = build(:celebrity, shop: shop)
        @wikipedia = Wikipedia.new(wikipedia_celebrity)
        @no_wikipedia = Wikipedia.new(regular_customer)
    end


    it "sets the customer" do
    end

    describe "data" do
        context "when customer has a wikipedia page" do
            it "returns a customer's Wikipedia data" do
                expect(@wikipedia.data).to be_an_instance_of(Array)
            end
        end

        context "when customer does not have a wikipedia page" do
            it "returns nil" do
                expect(@no_wikipedia.data).not_to be
            end
        end
    end

    describe "bio" do
        context "when customer has wikipedia data" do
            it "returns a customer's Wikipedia data" do
                expect(@wikipedia.bio).to be_an_instance_of(String)
            end
        end

        context "when customer does not have wikipedia data" do
            it "returns nil" do
                expect(@no_wikipedia.bio).not_to be
            end
        end
    end

    describe "url" do
        context "when customer has wikipedia data" do
            it "returns a customer's Wikipedia data" do
                expect(@wikipedia.url).to be_an_instance_of(String)
            end
        end

        context "when customer does not have wikipedia data" do
            it "returns nil" do
                expect(@no_wikipedia.url).not_to be
            end
        end
    end

end
