class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :percentage, :quantity



  def percentage_off
    percentage = (self.percentage * 100).to_i
  end

  def self.merchant_identifier
    id = self.distinct.pluck(:merchant_id)
  end

end