class GetCelebrityStatus

  def self.call(celebrity)
    return unless celebrity.first_name && celebrity.last_name

    if celebrity.full_name.ascii_only?

      imdb_data = GetIMDB.call(celebrity)

      if imdb_data
        celebrity.imdb_url = "http://www.imdb.com/name/" + imdb_data["id"]
        celebrity.imdb_bio = imdb_data["description"]
      end

      wikipedia_data = GetWikipedia.call(celebrity)

      if wikipedia_data
        celebrity.wikipedia_url = wikipedia_data[:url]
        celebrity.wikipedia_bio = wikipedia_data[:bio]  
      end

    end
    
    social_data = Fullcontact.get_data_array(celebrity)
    celebrity.set_social_data(social_data) if social_data
      
    unless celebrity.celebrity?
      celebrity.errors.add(:body, "This ain't no celebrity, kid")
    end
  end



end