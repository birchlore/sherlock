require 'spec_helper'
require 'shared_examples'

describe Instagram, :vcr do
  include_context 'shared examples'

  before(:all) do
    shop = build(:shop)
    super_celebrity = build(:super_celebrity, shop: shop, klout_url: 'http://klout.com/Ericbobmyers')
    regular_customer = build(:twitter_celebrity, shop: shop)
    @instagram = Instagram.new(super_celebrity)
    @klout = Klout.new(super_celebrity)
    @no_instagram = Instagram.new(regular_customer)
  end

  it 'sets the customer, id, and followers' do
  end

  describe 'id' do
    context 'when customer has an Instagram profile' do
      it 'returns the instagram ID' do
        expect(@instagram.id).to be_an(String)
      end
    end

    context 'when customer does not have an Instagram profile' do
      it 'returns nil' do
        expect(@no_instagram.id).to be nil
      end
    end
  end

  describe 'followers' do
    context 'when customer has Instagram followers and an instagram ID' do
      it "returns a customer's Instagram follower count" do
        expect(@instagram.followers).to be_an(Integer)
      end
    end

    context 'when customer does not have Instagram followers or instagram ID' do
      it 'returns nil' do
        expect(@no_instagram.followers).to be nil
      end
    end
  end
end
