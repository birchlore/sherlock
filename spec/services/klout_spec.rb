require 'spec_helper'
require 'shared_examples'


describe Klout, :vcr do
    include_context "shared examples"

    describe "get_hash" do
      it "gets the users klout hash from klout API" do
        expect(Klout.get_hash(instagram_celebrity)).to be_a(Hash)
      end
    end

    describe "get_score" do
      it "gets the users klout score from their klout hash" do
        expect(Klout.get_score(instagram_celebrity)).to be_a(Float)
      end
    end

end
