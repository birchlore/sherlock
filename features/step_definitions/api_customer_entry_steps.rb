
# Then "a celebrity is added" do
#   binding.pry
#   customer_params = attributes_for(:wikipedia_celebrity)
#   access_token = $shopify_token
#   callback_url   = "https://#{$shopify_domain}/hooks/new_customer_callback"

#   headers = {
#     'X-Shopify-Access-Token' => access_token,
#     content_type: 'application/json',
#     accept: 'application/json'
#   }
 
#   response = RestClient.post(callback_url(customer_params), headers)
# end

# Then "I should get an email notification that the customer is a celebrity" do
#   binding.pry
#   NotificationMailer.celebrity_notification.should_receive(:celebrity).with(Celebrity.last)
# end

# Then "the celebrity should be added to my celebrities list in the app" do
#   @customer = create(:celebrity, :shop=> @shop, :first_name=>"  Noah", :last_name=>"Kagan ")
# end

# When "a noncelebrity is added" do
#   @customer = create(:celebrity, :shop=> @shop, :first_name=>"hArRy", :last_name=>"tRUman")
# end

# Then "I should not get an email notification that the customer is a celebrity" do
#   fill_in :celebrity_email, :with => @customer.email
#   fill_in :celebrity_first_name, :with => @customer.first_name
#   fill_in :celebrity_last_name, :with => @customer.last_name
#   click_button 'Manual Scan'
# end


# Then "the celebrity should not be added to my celebrities list in the app" do
#   expect(page).to have_css('.celebrity-row')
# end

