require 'spec_helper'

describe Celebrity do
  it "has a valid factory" do
    expect(FactoryGirl.build(:celebrity)).to be_valid
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

end