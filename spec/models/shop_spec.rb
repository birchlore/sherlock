require 'spec_helper'

describe Shop do

  before(:each) do
    @shop1 = FactoryGirl.build(:shop)
    @shop2 = FactoryGirl.build(:shop)
  end

  it "has a valid factory" do
    expect(FactoryGirl.build(:shop)).to be_valid
  end

  it 'should have default settings' do
      expect(@shop1.imdb_notification).to eq(false)
  end

  it 'should toggle its settings without affecting other stores' do
	@shop1.update_attributes(imdb_notification: true, twitter_follower_threshold: 999, wikipedia_notification: false)
	expect(@shop1.imdb_notification).to eq(true)
	expect(@shop1.twitter_follower_threshold).to eq(999)
	expect(@shop1.wikipedia_notification).to eq(false)

	expect(@shop2.imdb_notification).to eq(false)
  end


end