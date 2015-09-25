Given "I visit the login page" do
  visit "/login"
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

When "I am a logged in user" do
  step "I visit the login page"
  step "I supply my shopify url"
  step "I get taken to the app index page"
end

Then "I install the app" do
  click_link_or_button "Install Groupie Test Environment"
end

When "I have enabled imdb" do
  Shop.last.update_attributes!({:imdb_notification => true})
end

Given /^the customer is a (.+) celebrity$/ do |type|
  celebrity_type = (type + "_celebrity").to_sym
  @customer = build(celebrity_type, :shop => Shop.last)
end

When /^I wait (.+) seconds$/ do |seconds|
  sleep seconds.to_i
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

Then "the customer should be saved to the database" do
  expect(Shop.last.celebrities.where(email: @customer.email).count).to eq(1)
end

When "pry" do
  binding.pry
end
