class CreatePages < ActiveRecord::Migration[8.1]
  def change
    create_table :pages do |t|
      t.string :name, null: false
      t.text :content, null: false
      t.string :aasm_state, null: false
      t.integer :display_order, null: false, default: 1
      t.string :top_nav, null: false
      t.string :bottom_nav

      t.timestamps
    end
  end
end
