class CreateRecipients < ActiveRecord::Migration[8.1]
  def change
    create_table :recipients, id: :uuid do |t|
      t.references :recipiable, polymorphic: true, type: :uuid, null: false
      t.references :mailer, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
