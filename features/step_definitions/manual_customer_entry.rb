Given /^I am a logged in user$/ do
  visit root_path
  fill_in :shop, :with => "sherlocks-spears"
  click_button 'Install'
  expect(page).to have_content('Log in to manage')
  # binding.pry
  fill_in :login, :with => 'jackson@vivomasks.com'
  fill_in :password, :with => "Jh4572"
  click_button 'Log in'
  expect(page).to have_content("We'll automatically")
end



Given /^the customer is a twitter celebrity$/ do
  @customer = create(:celebrity, :shop => @shop, :email => 'samantha@samanthaettus.com')
end

Given "the customer has a wikipedia page" do
  @customer = create(:celebrity, :shop=> @shop, :first_name=>"Noah", :last_name=>"Kagan")
end

Given "the customer has an IMDB page" do
  @customer = create(:celebrity, :shop=> @shop, :first_name=>"Jackson", :last_name=>"Cunningham")
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










