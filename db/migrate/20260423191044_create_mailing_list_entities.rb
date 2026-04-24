class CreateMailingListEntities < ActiveRecord::Migration[8.1]
  def change
    create_table :mailing_list_entities, id: :uuid do |t|
      t.string :email, null: false
      t.string :aasm_state, null: false

      t.timestamps
    end
  end
end
