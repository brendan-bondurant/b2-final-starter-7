class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :percentage, :quantity



  def percentage_off
    percentage = (self.percentage * 100).to_i
  end
end