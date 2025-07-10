class Airtable::WarehouseSKU < Norairrecord::Table
  self.base_key = "appK53aN0fz3sgJ4w"
  self.table_name = "tblvSJMqoXnQyN7co"

  def sku = fields["SKU"]
  def name = fields["Name (Must Match Poster Requests)"]
  def in_stock = fields["In Stock"]
  def unit_cost = fields["Unit Cost"]
  def item_type = fields["Item Type"]
end
