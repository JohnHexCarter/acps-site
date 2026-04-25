class AddStateToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :aasm_state, :string, null: false
  end
end
