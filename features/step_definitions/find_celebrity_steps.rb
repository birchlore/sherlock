When "a non celebrity customer is added" do
 post :celebrities, celebrity: FactoryGirl.attributes_for(:celebrity, :shop=> @shop, :first_name=>"Birglend", :last_name=>"Firglingham", :email=>"birglendfirglingham@gmail.com")
end

Then "the customer should not be saved to the database" do
  expect(@shop.celebrities.where(id: @customer.id)).not_to exist
end
