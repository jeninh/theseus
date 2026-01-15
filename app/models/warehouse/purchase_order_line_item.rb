# frozen_string_literal: true

# == Schema Information
#
# Table name: warehouse_purchase_order_line_items
#
#  id                :bigint           not null, primary key
#  quantity          :integer          not null
#  unit_cost         :decimal(10, 2)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  purchase_order_id :bigint           not null
#  sku_id            :bigint           not null
#
# Indexes
#
#  index_warehouse_purchase_order_line_items_on_purchase_order_id  (purchase_order_id)
#  index_warehouse_purchase_order_line_items_on_sku_id             (sku_id)
#
# Foreign Keys
#
#  fk_rails_...  (purchase_order_id => warehouse_purchase_orders.id)
#  fk_rails_...  (sku_id => warehouse_skus.id)
#
class Warehouse::PurchaseOrderLineItem < ApplicationRecord
  belongs_to :purchase_order, class_name: "Warehouse::PurchaseOrder", inverse_of: :line_items
  belongs_to :sku, class_name: "Warehouse::SKU"

  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
