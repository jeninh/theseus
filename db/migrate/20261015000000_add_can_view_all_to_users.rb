class AddCanViewAllToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :can_view_all, :boolean, default: false, null: false
  end
end
