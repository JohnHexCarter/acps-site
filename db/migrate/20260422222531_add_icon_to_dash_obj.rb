class AddIconToDashObj < ActiveRecord::Migration[8.1]
  def change
    add_column :dash_objects, :icon_str, :string
  end
end
