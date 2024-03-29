require 'rest_client'
require 'json'

require 'cucumber/rails'

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end

include FactoryGirl::Syntax::Methods

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.javascript_driver = :chrome

Capybara.default_max_wait_time = 5
Capybara.server_port = 23_456

def install_app
  step 'I visit the login page'
  step 'I supply my shopify url'
  step 'I get taken to Oauth page'
  step 'I supply my shopify credentials'
  result = unless page.has_content?('Logged in')
             step 'I install the app'
             step 'I skip the onboarding process'
             step 'I get taken to the app index page'
             true
           else
             false
           end
  $shopify_token = Shop.last.shopify_token
  $shopify_domain = Shop.last.shopify_domain
  result
end

def uninstall_app
  access_token = $shopify_token
  revoke_url   = "https://#{$shopify_domain}/admin/oauth/revoke"

  headers = {
    'X-Shopify-Access-Token' => access_token,
    content_type: 'application/json',
    accept: 'application/json'
  }

  response = RestClient.delete(revoke_url, headers)
  decoded = JSON.parse(response.body)['permission']
  decoded['access_token'] # 'secret'

  # stub_request(:delete, revoke_url).
  # with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Shopify-Access-Token'=> access_token}).
  # to_return(:status => 200, :body => "", :headers => {})
end

Before do
  $was_installed ||= false
  unless $was_installed
    unless install_app
      uninstall_app
      install_app
    end
    $was_installed = true
  end
end

at_exit do
  uninstall_app
end

# # Given "I am at the homepage" do
#   visit '/'
# # When "I supply my shopify url" do
#   fill_in :shop, :with => "sherlocks-spears"
#   click_button 'Install'
# # Then "I get taken to Oauth page" do
#   expect(page).to have_content('Log in to manage')
# # When "I supply my shopify credentials" do
#   fill_in :login, :with => 'jackson@vivomasks.com'
#   fill_in :password, :with => "Jh4572"
#   click_button 'Log in'
# # Then "I get taken to the app index page" do
#   expect(page).to have_content("We'll automatically")

# Before(:all) do
#   #uninstall (if there)
#   #do the install process
# end

# Around do |scenario, block|
#   VCR.use_cassette(scenario.feature.name + " " + scenario.name) do
#     block.call
#   end
# end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     # { :except => [:widgets] } may not do what you expect here
#     # as Cucumber::Rails::Database.javascript_strategy overrides
#     # this setting.
#     DatabaseCleaner.strategy = :truncation
#   end
#
#   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :truncation

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

Before('@javascript') do
  # Forces all threads to share the same connection. This works on
  # Capybara because it starts the web server in a thread.
  ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
end
