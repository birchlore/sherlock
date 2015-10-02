require 'spec_helper'
require 'shared_examples'


describe Youtube, :vcr do
    include_context "shared examples"

     before(:all) do
        shop = build(:shop)
        youtube_celebrity = build(:super_celebrity, shop: shop, youtube_username: "ericbobmyers")
        regular_customer = build(:celebrity, shop: shop)
        @youtube = Youtube.new(youtube_celebrity)
        @no_youtube = Youtube.new(regular_customer)
     end

    it "sets customer, social data, and hash" do
    end

    describe "hash" do
      it "gets the users youtube hash from youtube API" do
        expect(@youtube.hash).to be_a(Hash)
      end
    end

    describe "subscribers" do
      it "gets the users youtube subscribers from their youtube hash" do
        expect(@youtube.subscribers).to be_a(Integer)
      end
    end

    describe "views" do
      it "gets the users youtube views from their youtube hash" do
        expect(@youtube.views).to be_a(Integer)
      end
    end

end
