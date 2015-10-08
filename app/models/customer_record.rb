require 'pry'

class CustomerRecord < ActiveRecord::Base
  belongs_to :shop


  def increase_count
    self.count += 1
    self.save!
  end



end