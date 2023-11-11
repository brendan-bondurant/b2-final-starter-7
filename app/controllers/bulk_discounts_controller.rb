class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:new, :create, :index]
  def index
    # merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
  end

  def show
      
  end
  def new
    # @merchant = Merchant.find(params[:merchant_id])
  end

  def create
# require 'pry'; binding.pry
  BulkDiscount.create!(bulk_discount_params.merge(merchant_id: params[:merchant_id])) 
  
    redirect_to merchant_bulk_discounts_path
  end


  private

def bulk_discount_params
  params.require(:bulk_discount).permit(:percentage, :quantity)
end

def find_merchant
  @merchant = Merchant.find(params[:merchant_id])
end
end