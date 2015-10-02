require 'spec_helper'
require 'shared_examples'



describe GetJSON, :vcr do
    include_context "shared examples"

    describe "call" do
        context "when URI has valid JSON response" do
            it "gets a JSON hash from a URI" do
                expect(GetJSON.call(json_uri)).to be
            end
        end

        context "when URI has no valid JSON response" do
            it "returns nil" do
                expect(GetJSON.call(invalid_page)).not_to be
            end
        end

        # context "when there's a timeout" do
        #     it "returns nil" do
        #         source = "http://www.imdb.com/xml/find?json=1&nr=1&nm=on&q=FRED+FREE"
        #         expect(GetJSON.call(source)).to be nil
        #     end
        # end
    end

end


