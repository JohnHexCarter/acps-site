# frozen_string_literal: true

# id            id
# subject       string, null: false
# aasm_state    string, null: false, default: 'draft'
# published_at  datetime

class Mailer < ApplicationRecord
  include AASM

  has_rich_text :body

  has_many :recipients

  has_many :users, through: :recipients, source: :recipiable, source_type: 'User'
  has_many :mailing_list_entities, through: :recipients, source: :recipiable, source_type: 'MailingListEntity'

  validates :subject, presence: true

  aasm do
    state :draft, initial: true
    state :published

    event :publish do
      transitions from: :draft, to: :published
    end
  end
end
