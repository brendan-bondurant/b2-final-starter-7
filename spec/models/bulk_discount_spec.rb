require 'rails_helper'

describe BulkDiscount do
  before (:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Coffee Stuff")
    @bulkdiscount1 = @merchant1.bulk_discounts.create!(percentage: 0.10, quantity: 10)
    @bulkdiscount2 = @merchant1.bulk_discounts.create!(percentage: 0.30, quantity: 20)
    @bulkdiscount3 = @merchant2.bulk_discounts.create!(percentage: 0.15, quantity: 15)
  end

  describe "validations" do
    it { should validate_presence_of :percentage }
    it { should validate_presence_of :quantity }
  end
  
  describe "relationships" do
    it { should belong_to :merchant }
  end

  describe '#percentage_off' do
    it "turns the decimal into a percentage" do
      expect(@bulkdiscount1.percentage_off).to eq(10)
      expect(@bulkdiscount2.percentage_off).to eq(30)
      expect(@bulkdiscount3.percentage_off).to eq(15)
    end
  
  end
end