require 'open-uri'
require 'json'
require 'pry'

class Customer < ActiveRecord::Base
	belongs_to :shop
	# validates_presence_of :first_name, :on => :create
 #    validates_presence_of :last_name, :on => :create
 #    validates_presence_of :shop, :on => :create
 #    validates :shopify_id, uniqueness: true, if: 'shopify_id.present?', :on => :create

	def duplicate?
		self.shop.customers.where(shopify_id: self.shopify_id).first || self.shop.celebrities.where(shopify_id: self.shopify_id).first
	end
end
