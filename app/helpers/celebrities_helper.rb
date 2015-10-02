module CelebritiesHelper

    def has_wikipedia?(celebrity)
      link_to 'Yes', celebrity.wikipedia_url, :target=>"_blank" if celebrity.wikipedia_url.present?
    end

  def has_imdb?(celebrity)
    link_to 'Yes', celebrity.imdb_url, :target=>"_blank" if celebrity.imdb_url.present?
  end

  def twitter_follower_count(celebrity)
    threshold = current_shop.twitter_follower_threshold
    followers = celebrity.twitter_followers
    if followers && followers > threshold
      link_to followers, celebrity.twitter_url, :target=>"_blank"
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
    if celebrity.angellist_bio
      celebrity.angellist_bio
    elsif celebrity.linkedin_bio
      celebrity.linkedin_bio
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
    threshold = celebrity.shop.klout_score_threshold
    score = celebrity.klout_score
    score if score && score > threshold
  end

  def youtube_subscriber_count(celebrity)
    threshold = celebrity.shop.youtube_subscriber_threshold
    subscribers = celebrity.youtube_subscribers
    subscribers if subscribers && subscribers > threshold
  end

  def instagram_follower_count(celebrity)
    threshold = celebrity.shop.instagram_follower_threshold
    followers = celebrity.instagram_followers
    followers if followers && followers > threshold
  end

end
