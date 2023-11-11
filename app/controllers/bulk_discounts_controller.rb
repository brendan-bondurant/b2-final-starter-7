class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:new, :create, :index, :destroy, :show]
  
  def index
    @discounts = @merchant.bulk_discounts
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end
  
  def new
  
  end

  def edit

  end



  def create
    BulkDiscount.create!(bulk_discount_params.merge(merchant_id: params[:merchant_id])) 
  
    redirect_to merchant_bulk_discounts_path
  end

  def destroy
    discount = BulkDiscount.find(params[:id])
    discount.destroy

    redirect_to merchant_bulk_discounts_path(@merchant.id)
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:percentage, :quantity)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end