require 'spec_helper'
require 'shared_examples'

describe GetJSON, :vcr do
  include_context 'shared examples'

  describe 'call' do
    context 'when URI has valid JSON response' do
      it 'gets a JSON hash from a URI' do
        expect(GetJSON.call(json_uri)).to be
      end
    end

    context 'when URI has no valid JSON response' do
      it 'returns nil' do
        expect(GetJSON.call(invalid_page)).not_to be
      end
    end
  end
end
