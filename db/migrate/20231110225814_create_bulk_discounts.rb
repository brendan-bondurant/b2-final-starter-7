class CreateBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bulk_discounts do |t|
      t.float :percentage
      t.integer :quantity

      t.timestamps
    end
  end
end
