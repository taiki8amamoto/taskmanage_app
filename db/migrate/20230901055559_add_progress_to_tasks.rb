class AddProgressToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :progress, :integer, null: false, default: 0
  end
end
