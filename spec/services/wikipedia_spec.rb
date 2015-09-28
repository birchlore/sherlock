require 'spec_helper'
require 'shared_examples'



describe GetWikipedia, :vcr do
    include_context "shared examples"

    describe "call" do
        context "when customer has a wikipedia page" do
            it "returns a customer's Wikipedia data" do
                expect(GetWikipedia.call(wikipedia_celebrity)).to be_an_instance_of(Hash)
            end
        end

        context "when customer does not have a wikipedia page" do
            it "returns nil" do
                expect(GetWikipedia.call(celebrity)).not_to be
            end
        end
    end

end
