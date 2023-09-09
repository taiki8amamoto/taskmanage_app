class AddAdminToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :integer, null: false, default: 5
  end
end
