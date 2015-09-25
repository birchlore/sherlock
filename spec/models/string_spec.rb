require 'spec_helper'

describe String, :vcr do

  let(:wikipedia_dead_celebrity_string) {
   "Robert Lee Frost (March 26, 1874 – January 29, 1963) was an American poet. His work was initially published in England before it was published in America."
  }
  let(:wikipedia_alive_celebrity_string) {
   "Robert Lee Frost (March 26, 1974) was an American poet. His work was initially published in England before it was published in America."
  }

  let(:common_string) {
   "This is a common name and may refer to many people"
  }

  let(:redirect_string) {
   "This is a redirect. please choose wisely"
  }



describe "is_dead?" do
  it "returns true for a dead celebrity" do
    expect(wikipedia_dead_celebrity_string.is_dead?).to be
  end

  it "returns false for an alive celebrity" do
    expect(wikipedia_alive_celebrity_string.is_dead?).not_to be
  end
end


describe "is_common?" do
  it "returns true if string contains 'may refer to'" do
    expect(common_string.is_common?).to be
  end

  it "returns false if string does not contain 'may refer to'" do
    expect(wikipedia_alive_celebrity_string.is_common?).not_to be
  end
end


describe "is_a_redirect?" do
  it "returns true if string contains 'This is a redirect'" do
    expect(redirect_string.is_a_redirect?).to be
  end

  it "returns false if string does not contain 'This is a redirect" do
    expect(wikipedia_alive_celebrity_string.is_a_redirect?).not_to be
  end
  
end



end