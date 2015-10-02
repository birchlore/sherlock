require 'spec_helper'
require 'shared_examples'


describe Klout, :vcr do
    include_context "shared examples"

    before(:all) do
      shop = build(:shop)
      @super_celebrity = build(:super_celebrity, shop: shop, klout_id: 27043)
      @klout = Klout.new(@super_celebrity)
    end

    it "sets the customer and hash" do
    end

    describe "hash" do
      it "gets the users klout hash from klout API" do
        expect(@klout.hash(@super_celebrity)).to be_a(Hash)
      end
    end

    describe "score" do
      it "gets the users klout score from their klout hash" do
        expect(@klout.score).to be_a(Float)
      end
    end

end
