Given "the customer is a celebrity with incorrect whitespaces" do
  @customer = build(:celebrity, :first_name=>"  Noah", :last_name=>"Kagan ")
end

Given "the customer is a celebrity with incorrect capitalization" do
  @customer = build(:celebrity, :first_name=>"hArRy", :last_name=>"tRUman")
end

Given "the customer is not a celebrity" do
  @customer = build(:celebrity, :first_name=>"Birglend", :last_name=>"Firglingham", :email=>"birglendfirglingham@gmail.com")
end


Then "I should see that the customer is not a celebrity" do
  expect(page).to have_content("ain't no celebrity")
end

Then "the customer should be saved to the database" do
  expect(Shop.last.celebrities.where(email: @customer.email).count).to eq(1)
end


Then "the customer should not be saved to the database" do
  expect(Shop.last.celebrities.where(email: @customer.email).count).to eq(0)
end




