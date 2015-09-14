Before do
  @shop = FactoryGirl.build(:shop, :imdb_notification => true)
end

Given "I am at the homepage" do
  visit root_path
end

When "I supply my shopify url" do
  fill_in :shop, :with => "sherlocks-spears"
  click_button 'Install'
end

Then "I get taken to Oauth page" do
  expect(page).to have_content('Log in to manage')
end

When "I supply my shopify credentials" do
  fill_in :login, :with => 'jackson@vivomasks.com'
  fill_in :password, :with => "Jh4572"
  click_button 'Log in'
end


Then "I get taken to the app index page" do
  expect(page).to have_content("We'll automatically")
end


Given /^the customer is a (.+) celebrity$/ do |type|
  celebrity_type = (type + "_celebrity").to_sym
  @customer = create(celebrity_type, :shop => @shop)
end

Given "the customer is a celebrity with incorrect whitespaces" do
  @customer = create(:celebrity, :shop=> @shop, :first_name=>"  Noah", :last_name=>"Kagan ")
end

Given "the customer is a celebrity with incorrect capitalization" do
  @customer = create(:celebrity, :shop=> @shop, :first_name=>"hArRy", :last_name=>"tRUman")
end

When /^I add the customer$/ do
  fill_in :celebrity_email, :with => @customer.email
  fill_in :celebrity_first_name, :with => @customer.first_name
  fill_in :celebrity_last_name, :with => @customer.last_name
  click_button 'Manual Scan'
end

Then /^I should see that the customer is a celebrity$/ do
  expect(page).to have_css('.celebrity-row')
end

Given "the customer does not have a Wikipedia page, IMDB page, or Twitter following" do
  @customer = create(:celebrity, :shop=> @shop, :first_name=>"Birglend", :last_name=>"Firglingham", :email=>"birglendfirglingham@gmail.com")
end


Then "I should not see that the customer is a celebrity" do
  expect(page).not_to have_css('.celebrity-row')
end










