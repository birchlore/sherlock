require 'spec_helper'

describe Celebrity do
  it "has a valid factory" do
    expect(FactoryGirl.build(:celebrity)).to_not be_valid
    expect(FactoryGirl.build(:twitter_celebrity)).to be_valid
    expect(FactoryGirl.build(:wikipedia_celebrity)).to be_valid
    expect(FactoryGirl.build(:imdb_celebrity)).to be_valid
  end

  it "is invalid without a firstname" do
    expect(FactoryGirl.build(:celebrity, first_name: "")).to_not be_valid
  end

  it "is invalid without a lastname" do
    expect(FactoryGirl.build(:celebrity, last_name: "")).to_not be_valid
  end

  it "returns a celebrity's full name as a string" do
    contact = FactoryGirl.build(:celebrity, first_name: "John", last_name: "Doe", email: "John@gmail.com")
    expect(contact.full_name).to eq("John Doe")
  end

  it "converts a celebrity's name to proper capitalization" do
    contact = FactoryGirl.create(:celebrity, first_name: "JoHN", last_name: "dOE", email: "John@gmail.com")
    expect(contact.full_name).to eq("John Doe")
  end

  context "celebrity status" do

    let(:shop) {
      create(:shop, :imdb_notification => true)
    }

    it 'should work for imdb' do

      expect(FactoryGirl.create(:imdb_celebrity, :shop => shop)).to be_valid

    end

  end

end