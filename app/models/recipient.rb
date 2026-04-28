# frozen_string_literal: true

# id                id
# recipiable_id     string
# recipiable_type   string
# mailer_id         string

class Recipient < ApplicationRecord
  belongs_to :recipiable, polymorphic: true
  belongs_to :mailer
end
