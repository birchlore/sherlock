class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  has_many :celebrities, :inverse_of => :shop

  def self.store(session)
    shop = self.new(shopify_domain: session.url, shopify_token: session.token)
    shop.save!
    shop.id
  end

  def self.retrieve(id)
    if Rails.env.test?
      shop = self.last
    else
      shop = self.where(id: id).first
    end
    if shop
      ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token)
    end
  end

end
