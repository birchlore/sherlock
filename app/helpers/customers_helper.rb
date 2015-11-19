module CustomersHelper
  def wikipedia_link(customer)
    if customer.wikipedia_url.present?
      link_to 'Yes', customer.wikipedia_url, target: '_blank'
    else
      '—'
    end
  end

  def imdb_link(customer)
    if customer.imdb_url.present?
      link_to 'Yes', customer.imdb_url, target: '_blank'
    else
      '—'
    end
  end

  def twitter_follower_count(customer)
    if !customer.scanned_on_social?
      '—'
    elsif customer.twitter_celebrity? && customer.twitter_url
      link_to customer.twitter_followers, customer.twitter_url, target: '_blank'
    elsif customer.twitter_celebrity?
      customer.twitter_followers
    else
      '—'
    end
  end

  def name(customer)
    if customer.shopify_url.present?
      link_to customer.full_name, 'https://' + customer.shopify_url, target: '_blank'
    else
      customer.full_name
    end
  end

  def bio(customer)
    if customer.twitter_bio
      customer.twitter_bio
    elsif customer.linkedin_bio
      customer.linkedin_bio
    elsif customer.angellist_bio
      customer.angellist_bio
    elsif customer.twitter_bio
      customer.twitter_bio
    elsif customer.wikipedia_bio
      customer.wikipedia_bio
    elsif customer.imdb_bio
      customer.imdb_bio
    else
      'No bio at this time.'
    end
  end

  def klout_score(customer)
    if !customer.scanned_on_social?
      '—'
    elsif customer.klout_celebrity?
      link_to customer.klout_score, 'https://klout.com/corp/score', target: '_blank'
    else
      '—'
    end
  end

  def youtube_subscriber_count(customer)
    if !customer.scanned_on_social?
      '—'
    elsif customer.youtube_celebrity? && customer.youtube_url
      link_to customer.youtube_subscribers, customer.youtube_url, target: '_blank'
    elsif customer.youtube_celebrity?
      subscribers
    else
      '—'
    end
  end

  def instagram_follower_count(customer)
    if !customer.scanned_on_social?
      '—'
    elsif customer.instagram_celebrity? && customer.instagram_url
      link_to customer.instagram_followers, customer.instagram_url, target: '_blank'
    elsif customer.instagram_celebrity?
      customer.instagram_followers
    else
      '—'
    end
  end
end
