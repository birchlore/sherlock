class GetWikipedia < Services
   def self.call(celebrity)
    source = "https://en.wikipedia.org/w/api.php?action=opensearch&search=" + celebrity.first_name + "%20" + celebrity.last_name + "&limit=1&namespace=0&format=json"
    
    json = GetJSON.call(source)
    return unless json[0].present? && json[0].upcase == celebrity.full_name.upcase

    wikipedia_url = json[3].first
    bio = json[2].first

    return if !bio || bio.is_common? || bio.is_dead?

    bio = "This person has an AKA. See their Wikipedia page." if bio.is_a_redirect?
        
    {url: wikipedia_url, bio: bio}
    
  end
end