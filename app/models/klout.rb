class Klout
  
  def initialize(customer)
    @customer = customer
    @hash = hash(customer)
  end

  def hash(customer)
    klout_id = customer.klout_id
    return unless klout_id
    source = "http://api.klout.com/v2/user.json/#{klout_id}?key=#{Figaro.env.klout_api_key}"
    json = GetJSON.call(source)
  end

  def score
    return unless @hash
    @hash.try(:[],'score').try(:[], 'score').try(:to_i)
  end

end