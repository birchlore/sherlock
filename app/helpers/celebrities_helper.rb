module CelebritiesHelper

    def has_wikipedia?(celebrity)
     if celebrity.wikipedia_url.present?
        link_to 'Yes', celebrity.wikipedia_url
      else
        "No"
      end
    end

  def has_imdb?(celebrity)
    if celebrity.imdb_url.present?
      link_to 'Yes', celebrity.imdb_url
    else
      "No"
    end
  end

  def twitter_followers(celebrity)
    if celebrity.followers > 10000
      celebrity.followers
    else
      "N/A"
    end
  end

  def description(celebrity)
    if celebrity.wikipedia_description
      celebrity.wikipedia_description
    elsif celebrity.imdb_description
      celebrity.imdb_description
    else
      "N/A"
    end
  end


end
