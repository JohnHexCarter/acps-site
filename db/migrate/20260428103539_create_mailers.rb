class CreateMailers < ActiveRecord::Migration[8.1]
  def change
    create_table :mailers, id: :uuid do |t|
      t.string :subject, null: false
      t.string :aasm_state, null: false
      t.datetime :published_at

      t.timestamps
    end
  end
end
