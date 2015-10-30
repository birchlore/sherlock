When /^I upgrade to the (.+) plan$/ do |plan|
  click_link_or_button "Settings & Notifications"
  click_link_or_button "change plan"
  choose("shop_plan_#{plan}")
  click_link_or_button "Update Plan"
  click_link_or_button "Approve charge"
end

Then "I should see my plan is upgraded" do
  expect(page).to have_content("Yay")
end