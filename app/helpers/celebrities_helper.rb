module CelebritiesHelper

    def wikipedia_link(celebrity)
      if celebrity.wikipedia_url.present?
        link_to 'Yes', celebrity.wikipedia_url, :target=>"_blank" 
      else
        "—"
      end
    end

  def imdb_link(celebrity)
    if celebrity.imdb_url.present?
      link_to 'Yes', celebrity.imdb_url, :target=>"_blank" 
    else
      "—"
    end
  end

  def twitter_follower_count(celebrity)
    if celebrity.twitter_celebrity? && celebrity.twitter_url
      link_to celebrity.twitter_followers, celebrity.twitter_url, :target=>"_blank"
    elsif celebrity.twitter_celebrity?
      celebrity.twitter_followers
    else
      "—"
    end
  end

  def name(celebrity)
    if celebrity.shopify_url.present?
      link_to celebrity.full_name, "https://" + celebrity.shopify_url, :target=>"_blank"
    else
     celebrity.full_name
   end
  end

  

  def bio(celebrity)
    if celebrity.twitter_bio
      celebrity.twitter_bio
    elsif celebrity.linkedin_bio
      celebrity.linkedin_bio
    elsif celebrity.angellist_bio
      celebrity.angellist_bio
    elsif celebrity.twitter_bio
      celebrity.twitter_bio
    elsif celebrity.wikipedia_bio
      celebrity.wikipedia_bio
    elsif celebrity.imdb_bio
      celebrity.imdb_bio
    else
      "No bio at this time."
    end
  end

  def klout_score(celebrity)
    if celebrity.klout_celebrity?
      link_to celebrity.klout_score, "https://klout.com/corp/score", :target=>"_blank"
    else
      "—"
    end
  end

  def youtube_subscriber_count(celebrity)
    if celebrity.youtube_celebrity? && celebrity.youtube_url
      link_to subscribers, celebrity.youtube_url, :target=>"_blank"
    elsif celebrity.youtube_celebrity?
      subscribers
    else
      "—"
    end
  end

  def instagram_follower_count(celebrity)
    if celebrity.instagram_celebrity? && celebrity.instagram_url
      link_to celebrity.instagram_followers, celebrity.instagram_url, :target=>"_blank"
    elsif celebrity.instagram_celebrity?
      celebrity.instagram_followers
    else
      "—"
    end
  end

end
