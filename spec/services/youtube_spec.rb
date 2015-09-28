require 'spec_helper'
require 'shared_examples'


describe Youtube, :vcr do
    include_context "shared examples"

    describe "get_hash" do
      it "gets the users youtube hash from youtube API" do
        expect(Youtube.get_hash(super_celebrity)).to be_a(Hash)
      end
    end

    describe "get_subscribers" do
      it "gets the users youtube subscribers from their youtube hash" do
        expect(Youtube.get_subscribers(youtube_hash)).to be_a(Integer)
      end
    end

    describe "get_views" do
      it "gets the users youtube views from their youtube hash" do
        expect(Youtube.get_views(youtube_hash)).to be_a(Integer)
      end
    end

end
