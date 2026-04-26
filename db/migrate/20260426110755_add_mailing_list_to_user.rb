class AddMailingListToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :mailing_list, :boolean, default: false
  end
end
