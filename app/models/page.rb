# frozen_string_literal: true

# id            id
# name          string, null: false
# content       text,   null: false
# aasm_state    text,   null: false, default: 'draft'
# display_order int,    null: false, default: 1
# top_nav       string, null: false
# bottom_nav    string

class Page < ApplicationRecord
  include AASM

  validates :name, presence: true, uniqueness: true
  validates :content, presence: true
  validates :aasm_state, presence: true
  validates :top_nav, presence: true
  validate :display_order_is_positive

  aasm do
    state :draft, initial: true
    state :published, :archived

    event :publish do
      transitions from: %i[draft archived], to: :published
    end

    event :redraft do
      transitions from: %i[published archived], to: :draft
    end

    event :archive do
      transitions from: %i[draft published], to: :archived
    end
  end

  private

  def display_order_is_positive
    return if display_order&.positive?

    errors.add(:display_order, 'can only be positive')
  end
end
