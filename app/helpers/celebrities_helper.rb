module CelebritiesHelper

    def has_wikipedia?(celebrity)
      if celebrity.wikipedia_url.present?
        link_to 'Yes', celebrity.wikipedia_url, :target=>"_blank" 
      else
        "—"
      end
    end

  def has_imdb?(celebrity)
    if celebrity.imdb_url.present?
      link_to 'Yes', celebrity.imdb_url, :target=>"_blank" 
    else
      "—"
    end
  end

  def twitter_follower_count(celebrity)
    threshold = current_shop.twitter_follower_threshold
    followers = celebrity.twitter_followers
    if followers && followers > threshold && celebrity.twitter_url
      link_to followers, celebrity.twitter_url, :target=>"_blank"
    elsif followers && followers > threshold
      followers
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
    elsif celebrity.wikipedia_bio
      celebrity.wikipedia_bio
    elsif celebrity.imdb_bio
      celebrity.imdb_bio
    else
      "No bio at this time."
    end
  end

  def klout_score(celebrity)
    threshold = celebrity.shop.klout_score_threshold
    score = celebrity.klout_score
    if score && score > threshold
      link_to score, "https://klout.com/corp/score", :target=>"_blank"
    else
      "—"
    end
  end

  def youtube_subscriber_count(celebrity)
    threshold = celebrity.shop.youtube_subscriber_threshold
    subscribers = celebrity.youtube_subscribers
    if subscribers && subscribers > threshold && celebrity.youtube_url
      link_to subscribers, celebrity.youtube_url, :target=>"_blank"
    elsif subscribers && subscribers > threshold
      subscribers
    else
      "—"
    end
  end

  def instagram_follower_count(celebrity)
    threshold = celebrity.shop.instagram_follower_threshold
    followers = celebrity.instagram_followers
    if followers && followers > threshold && celebrity.instagram_url
      link_to followers, celebrity.instagram_url, :target=>"_blank"
    elsif followers && followers > threshold
      followers
    else
      "—"
    end
  end

end
