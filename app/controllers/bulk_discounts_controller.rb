class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:new, :create, :index, :destroy, :show, :edit, :update]
  
  def index
    @discounts = @merchant.bulk_discounts
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end
  
  def new
  
  end

  def edit
      @discount = @merchant.bulk_discounts.find(params[:id])

  end

  def update
    discount = BulkDiscount.find(params[:id])
    #figure out stronger way to do this later
    discount.update(bulk_discount_params)

    redirect_to merchant_bulk_discounts_path(@merchant.id)
    
  end

  def create
    BulkDiscount.create!(bulk_discount_params.merge(merchant_id: params[:merchant_id])) 
  
    redirect_to merchant_bulk_discounts_path(@merchant.id)
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