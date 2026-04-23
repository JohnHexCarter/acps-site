FactoryBot.define do
  factory :mailing_list_entity do
    email { 'valid@gmail.com' }
    aasm_state { 'unconfirmed' }
  end
end
