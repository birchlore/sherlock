Given 'the customer has incorrect whitespaces' do
  @customer = build(:customer, first_name: '  Noah', last_name: 'Kagan ')
end

Given 'the customer has incorrect capitalization' do
  @customer = build(:customer, first_name: 'hArRy', last_name: 'tRUman')
end

Given 'the customer is dead' do
  @customer = build(:customer, first_name: 'Robert', last_name: 'Frost')
end

Given 'the customer is not a celebrity' do
  @customer = build(:customer, first_name: 'Birglend', last_name: 'Firglingham', email: 'birglendfirglingham@gmail.com')
end

Given 'the customer has a common name' do
  @customer = build(:customer, first_name: 'Sarah', last_name: 'Smith')
  @customer.shop.imdb_notification = false
end

Then 'I should see that the customer is not a celebrity' do
  expect(page).to have_content("ain't no celebrity")
end

Then 'the customer should not be saved to the database' do
  expect(Shop.last.customers.where(email: @customer.email).count).to eq(0)
end
