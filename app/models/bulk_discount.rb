class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :percentage, :quantity



  def percentage_off
    percentage = (self.percentage * 100).to_i
  end

  def make_percentage
    if self.percentage >= 1 
      self.percentage = (self.percentage / 100.0.round(2))
    end
    self.save
  end

end