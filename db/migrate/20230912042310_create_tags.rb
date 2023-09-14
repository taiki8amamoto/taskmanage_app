class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.references :task, foreign_key: true, null: false
      t.references :label, foreign_key: true, null: false

      t.timestamps
    end
  end
end
