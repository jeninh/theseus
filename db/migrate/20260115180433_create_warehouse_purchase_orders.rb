class CreateWarehousePurchaseOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :warehouse_purchase_orders do |t|
      t.string :supplier_name
      t.integer :supplier_id
      t.string :order_number
      t.text :notes
      t.date :required_by_date
      t.string :status, default: "draft"
      t.integer :zenventory_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :warehouse_purchase_orders, :zenventory_id, unique: true
    add_index :warehouse_purchase_orders, :order_number
  end
end
