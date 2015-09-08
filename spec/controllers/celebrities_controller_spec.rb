require 'spec_helper'

describe CelebritiesController do

  describe "POST #create" do
    before :each do
      @shop = FactoryGirl.create(:shop)
    end

    context "with valid attributes" do
      it "creates a new celebrity" do
        binding.pry
        expect{
          post :create, celebrity: FactoryGirl.attributes_for(:celebrity, :first_name=>"John", :last_name=>"Travolta").merge(shop: @shop)
        }.to change(Celebrity,:count).by(1)
      end

      it "redirects to the home page" do
      end

    end
    
    context "with invalid attributes" do
      it "does not save the new contact in the database"
      it "re-renders the :new template"
    end
  end
end