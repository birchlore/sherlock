require 'spec_helper'
require 'shared_examples'

describe String, :vcr do
  include_context 'shared examples'

  describe 'is_dead?' do
    it 'returns true for a dead celebrity' do
      expect(wikipedia_dead_celebrity_string.is_dead?).to be
    end

    it 'returns false for an alive celebrity' do
      expect(wikipedia_alive_celebrity_string.is_dead?).not_to be
    end
  end

  describe 'is_common?' do
    it "returns true if string contains 'may refer to'" do
      expect(common_string.is_common?).to be
    end

    it "returns false if string does not contain 'may refer to'" do
      expect(wikipedia_alive_celebrity_string.is_common?).not_to be
    end
  end

  describe 'is_a_redirect?' do
    it "returns true if string contains 'This is a redirect'" do
      expect(redirect_string.is_a_redirect?).to be
    end

    it "returns false if string does not contain 'This is a redirect" do
      expect(wikipedia_alive_celebrity_string.is_a_redirect?).not_to be
    end
  end
end
