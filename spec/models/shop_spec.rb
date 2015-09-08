require 'spec_helper'

describe Shop do
  it "has a valid factory" do
    expect(FactoryGirl.build(:shop)).to be_valid
  end
end