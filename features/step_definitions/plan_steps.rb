When /^I upgrade to the (.+) plan$/ do |plan|
  click_link_or_button "Settings & Notifications"
  click_link_or_button "change plan"
  choose("shop_plan_#{plan}")
  click_link_or_button "Update Plan"
  click_link_or_button "Approve charge" unless plan == "free"
end


Then "I should see my plan is upgraded" do
  expect(page).to have_content("Yay")
end


Then(/^I should have (\d+) imdb scans remaining$/) do |scans_remaining|
	expect(page).to have_content(scans_remaining)
end

Then(/^I should have unlimited imdb scans remaining$/) do
  expect(page).to have_content("Unlimited")
end

Then(/^I should have no social scans remaining$/) do
	expect(page).to have_content("disabled")
end

Then(/^I should have (\d+) social scans remaining$/) do |scans_remaining|
	expect(page).to have_content(scans_remaining)
end

Then(/^I should not be able to bulk scan$/) do
	expect(page).to have_button('Bulk Scan', disabled: true)
end

Then(/^I should be able to bulk scan$/) do
	expect(page).to have_button('Bulk Scan', disabled: false)
end


Then(/^I should see the teaser scan description$/) do
  expect(page).to have_content("1000")
end


Then(/^I should not see the teaser scan description$/) do
  expect(page).not_to have_content("1000")
end

