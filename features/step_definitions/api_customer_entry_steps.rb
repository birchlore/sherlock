Given "the app is installed" do
  @shop = create(:shop)
end

Then /^I should see "(.*)"$/ do |content|
  expect(page).to have_content(content)
end


When "a celebrity is added" do
  customer_params = {:first_name => "Tom", :last_name => "Cruise", :shop => @shop, :email => nil}
  post 'hooks/new_customer_callback', params: customer_params
end

Then "I should get an email notification that the customer is a celebrity" do
  NotificationMailer.celebrity_notification.should_receive(:celebrity).with(self)
end

Then "the celebrity should be added to my celebrities list in the app" do
  @customer = create(:celebrity, :shop=> @shop, :first_name=>"  Noah", :last_name=>"Kagan ")
end

Given "When a non-celebrity is added" do
  @customer = create(:celebrity, :shop=> @shop, :first_name=>"hArRy", :last_name=>"tRUman")
end

Then "I should not get an email notification that the customer is a celebrity" do
  fill_in :celebrity_email, :with => @customer.email
  fill_in :celebrity_first_name, :with => @customer.first_name
  fill_in :celebrity_last_name, :with => @customer.last_name
  click_button 'Manual Scan'
end


Then "the celebrity should not be added to my celebrities list in the app" do
  expect(page).to have_css('.celebrity-row')
end


When /^pry$/ do
  expect(page).to have_css('body')
  binding.pry
end