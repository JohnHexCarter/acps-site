class CreateDashObjects < ActiveRecord::Migration[8.1]
  def change
    create_table :dash_objects do |t|
      t.string :name, null: false
      t.string :namespace, null: false
      t.string :description

      t.timestamps
    end
    add_index :dash_objects, :namespace, unique: true
  end
end
