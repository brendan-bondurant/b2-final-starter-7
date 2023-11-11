class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    amount_off = 0
    discounts = bulk_discounts
    discounts.each do |discount|
      item = invoice_items.where("quantity > ?", discount.quantity)
        if item != nil
        before_discount = item.sum("unit_price * quantity")
        amount_off += (before_discount * discount.percentage)
      end
    end
    discounted_price = total_revenue - amount_off
    # require 'pry'; binding.pry
  end
end
