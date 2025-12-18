class AddCanUseIndiciaToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :can_use_indicia, :boolean, default: false, null: false
  end
end
