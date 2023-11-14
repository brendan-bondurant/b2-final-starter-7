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

  # def discounted_revenue
  #   total_revenue = invoice_items.sum('unit_price * quantity')
  #   total_discount = 0
  
  #   invoice_items.each do |invoice_item|
  #     max_discount = invoice_item.item.merchant.bulk_discounts
  #                                   .where('quantity <= ?', invoice_item.quantity)
  #                                   .maximum(:percentage)
  #     if max_discount
  #       total_discount += max_discount * invoice_item.quantity * invoice_item.unit_price
  #     end
  #   end
  
  #   (total_revenue - total_discount).round(2)
  # end


  def discounted_revenue
    total_revenue = invoice_items.sum('unit_price * quantity')
    total_discount = invoice_items.joins(item: { merchant: :bulk_discounts })
                              .group('invoice_items.id')
                              .sum do |invoice_item_id|
                                invoice_item = invoice_items.find(invoice_item_id.id)
                                max_percentage = invoice_item.item.merchant.bulk_discounts
                                .where('quantity <= ?', invoice_item.quantity)
                                .maximum(:percentage)
                                if max_percentage != nil
                                  max_percentage * invoice_item.quantity * invoice_item.unit_price
                                else
                                  0
                                end
                              end
    (total_revenue - total_discount).round(2)
  end

end

