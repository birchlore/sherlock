require 'pry'

class CustomerRecord < ActiveRecord::Base
  belongs_to :shop, :inverse_of => :celebrities


  def increase_count
    self.count += 1
    self.save!
  end



end