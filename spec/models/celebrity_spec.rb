require 'spec_helper'

describe Celebrity do
  it "has a valid factory" do
    expect(FactoryGirl.create(:celebrity)).to be_valid
  end

  it "is invalid without a firstname" do
    expect(FactoryGirl.build(:celebrity, first_name: nil)).to_not be_valid
  end

  it "is invalid without a lastname" do
    expect(FactoryGirl.build(:celebrity, last_name: nil)).to_not be_valid
  end

  it "returns a celebrity's full name as a string" do
    contact = FactoryGirl.create(:celebrity, first_name: "John", last_name: "Doe", email: "John@gmail.com")
    expect(contact.full_name).to eq("John Doe")
  end

end