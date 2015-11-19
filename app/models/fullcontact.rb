class Fullcontact
  def initialize(customer)
    @customer = customer
  end

  def data
    return unless @customer.email.present?
    source = 'https://api.fullcontact.com/v2/person.json?email=' + @customer.email + '&apiKey=' + ENV['full_contact_api_key']
    json = GetJSON.call(source)
    return if !json || json['message'] && json['message'].include?('Queued')
    @data ||= json['socialProfiles']
  end

  def profile_hash(profile_name)
    return unless @data
    @profile_hash = @data.find { |profile| profile['type'] == profile_name }
  end

  def profile_data(column)
    return unless @profile_hash && @profile_hash[column]
    @profile_data = @profile_hash[column]
  end
end
