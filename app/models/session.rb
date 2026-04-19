# frozen_string_literal: true

# id           id
# user_id      id
# ip_address   string
# user_agent   string

class Session < ApplicationRecord
  belongs_to :user
end
