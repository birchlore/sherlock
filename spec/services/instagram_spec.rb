require 'spec_helper'
require 'shared_examples'


describe Instagram, :vcr do
    include_context "shared examples"

    describe "get_id" do
        context "when customer has an Instagram profile" do
            it "returns the instagram ID" do
                expect(Instagram.get_id(instagram_celebrity)).to be_an(Integer)
            end
        end

        context "when customer does not have an Instagram profile" do
            it "returns nil" do
                expect(Instagram.get_id(twitter_celebrity)).to be nil
            end
        end
    end

    describe "get_followers" do
        context "when customer has Instagram followers and an instagram ID" do
            it "returns a customer's Instagram follower count" do
                instagram_celebrity.instagram_id = Instagram.get_id(instagram_celebrity)
                expect(Instagram.get_followers(instagram_celebrity)).to be_an(Integer)
            end
        end

        context "when customer does not have Instagram followers or instagram ID" do
            it "returns nil" do
                expect(Instagram.get_followers(twitter_celebrity)).to be nil
            end
        end
    end
end
