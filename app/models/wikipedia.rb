class Wikipedia

  def initialize(customer)
    @customer = customer
  end

  def data
    source = "https://en.wikipedia.org/w/api.php?action=opensearch&search=" + @customer.first_name + "%20" + @customer.last_name + "&limit=1&namespace=0&format=json"
    data ||= GetJSON.call(source)
    bio = data[2].first
    return if !bio || bio.is_common? || bio.is_dead?
    return unless data[0].present? && data[0].upcase == @customer.full_name.upcase
    @data = data
  end

  def bio
    return unless @data
    bio = @data[2].first
    bio = "This person has an AKA. See their Wikipedia page." if bio.is_a_redirect?
    @bio ||= bio
  end

  def url
    return unless @data
    @data[3].first
  end

end