require "rails_helper"

RSpec.describe "bulk discount show" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Coffee Stuff")

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @bulkdiscount1 = @merchant1.bulk_discounts.create!(percentage: 0.10, quantity: 10)
    @bulkdiscount2 = @merchant1.bulk_discounts.create!(percentage: 0.30, quantity: 20)
    @bulkdiscount3 = @merchant2.bulk_discounts.create!(percentage: 0.15, quantity: 15)

    

  end

  describe 'merchant#show' do
    
    it 'shows the quantity and percentage off' do
      visit merchant_bulk_discount_path(@merchant1, @bulkdiscount2)
      
      expect(page).to have_content(@bulkdiscount2.percentage_off)
      expect(page).to have_content(@bulkdiscount2.quantity)
    end
    
    it 'shows the quantity and percentage off test2' do
      visit merchant_bulk_discount_path(@merchant2, @bulkdiscount3)

      expect(page).to have_content(@bulkdiscount3.percentage_off)
      expect(page).to have_content(@bulkdiscount3.quantity)
    end
  
    it 'allows the discount to be edited' do
      visit merchant_bulk_discount_path(@merchant1, @bulkdiscount1)
      expect(page).to have_link("Change Discount")
      click_link "Change Discount"
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @bulkdiscount1))
      
      expect(find_field("bulk_discount[percentage]").value).to have_content(@bulkdiscount1.percentage)
      expect(find_field("bulk_discount[quantity]").value).to have_content(@bulkdiscount1.quantity)
      fill_in "bulk_discount[percentage]", with: 0.39
      fill_in "bulk_discount[quantity]", with: 29
      click_button "Update"
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      
      expect(page).to have_content("39%")
      expect(page).to have_content(29)
    end

    it 'allows the discount to be edited with integer' do
      visit edit_merchant_bulk_discount_path(@merchant1, @bulkdiscount1)
      
      expect(find_field("bulk_discount[percentage]").value).to have_content(@bulkdiscount1.percentage)
      expect(find_field("bulk_discount[quantity]").value).to have_content(@bulkdiscount1.quantity)
      fill_in "bulk_discount[percentage]", with: 39
      fill_in "bulk_discount[quantity]", with: 29
      click_button "Update"
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      
      expect(page).to have_content("39%")
      expect(page).to have_content(29)
    end

    it 'shows error when edited with string' do
      visit edit_merchant_bulk_discount_path(@merchant1, @bulkdiscount1)
      
      expect(find_field("bulk_discount[percentage]").value).to have_content(@bulkdiscount1.percentage)
      expect(find_field("bulk_discount[quantity]").value).to have_content(@bulkdiscount1.quantity)
      fill_in "bulk_discount[percentage]", with: "39%"
      fill_in "bulk_discount[quantity]", with: 29
      click_button "Update"
      
      expect(page).to have_content('Invalid input. Percent should be a number between 0 and 100 and quantity should be a number')
      fill_in "bulk_discount[percentage]", with: 39
      fill_in "bulk_discount[quantity]", with: "29 items"
      click_button "Update"
    
      expect(page).to have_content('Invalid input. Percent should be a number between 0 and 100 and quantity should be a number')
      fill_in "bulk_discount[percentage]", with: 39
      fill_in "bulk_discount[quantity]", with: 29
      click_button "Update"
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

      expect(page).to_not have_content('Invalid input. Percent should be a number between 0 and 100 and quantity should be a number')
      
      expect(page).to have_content("39%")
      expect(page).to have_content(29)
    end
  end
  describe 'back to dashboard' do
    it 'takes you back to the dashboard' do
      visit merchant_bulk_discount_path(@merchant1, @bulkdiscount2)

      expect(page).to have_link("Back to dashboard")
      click_link "Back to dashboard"
      expect(current_path).to eq(merchant_dashboard_index_path(@merchant1.id))
    end
  end
end