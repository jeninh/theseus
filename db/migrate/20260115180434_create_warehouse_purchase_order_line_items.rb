class CreateWarehousePurchaseOrderLineItems < ActiveRecord::Migration[8.0]
  def change
    create_table :warehouse_purchase_order_line_items do |t|
      t.references :purchase_order, null: false, foreign_key: { to_table: :warehouse_purchase_orders }
      t.references :sku, null: false, foreign_key: { to_table: :warehouse_skus }
      t.integer :quantity, null: false
      t.decimal :unit_cost, precision: 10, scale: 2

      t.timestamps
    end
  end
end
