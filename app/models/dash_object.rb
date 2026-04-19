# frozen_string_literal: true

# id          id
# name        string, null: false
# namespace   string, null: false
# description string

class DashObject < ApplicationRecord
  validates :name, presence: true
  validates :namespace, presence: true, uniqueness: true
end
