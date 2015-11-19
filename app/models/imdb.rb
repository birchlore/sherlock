class IMDB
  def initialize(celebrity)
    @celebrity = celebrity
  end

  def data
    source = 'http://www.imdb.com/xml/find?json=1&nr=1&nm=on&q=' + @celebrity.first_name + '+' + @celebrity.last_name
    json = GetJSON.call(source)
    return unless json
    if json['name_popular'].present?
      @imdb_data = json['name_popular'][0]
    elsif json['name_exact'].present?
      @imdb_data = json['name_exact'][0]
    end

    @imdb_data if @imdb_data.present? && @imdb_data['name'].upcase == @celebrity.full_name.upcase
  end

  def url
    return unless @imdb_data
    'http://www.imdb.com/name/' + @imdb_data['id']
  end

  def bio
    return unless @imdb_data
    @imdb_data['description']
  end
end
