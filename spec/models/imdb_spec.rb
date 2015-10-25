require 'spec_helper'
require 'shared_examples'


describe IMDB, :vcr do
    include_context "shared examples"

    before(:all) do
        shop = build(:shop)
        imdb_celebrity = build(:imdb_celebrity, shop: shop)
        regular_customer = build(:customer, shop: shop)
        @imdb = IMDB.new(imdb_celebrity)
        @no_imdb = IMDB.new(regular_customer)
    end

    describe "data" do

        context "when customer is and imdb celebrity" do
            it "gets a customer's IMDB data" do
                expect(@imdb.data).to be_an_instance_of(Hash)
            end
        end

        context "when customer is not an imdb celebrity" do
            it "returns nil" do
                expect(@no_imdb.data).not_to be
            end
        end

    end


    describe "url" do
        context "when there is a url" do
            it "returns the url" do
                expect(@imdb.url).to include("nm1080980")
            end
        end

        context "when there is no url" do
            it "returns nil" do
                expect(@no_imdb.url).not_to be
            end
        end
    end


    describe "bio" do
        context "when there is a bio" do
            it "returns the bio" do
                expect(@imdb.bio).to include("Actor")
            end
        end

        context "when there is not a bio" do
            it "returns nil" do
                expect(@no_imdb.bio).not_to be
            end
        end
    end

end



