FactoryBot.define do
  factory :mailing_list_entity do
    email { 'valid@gmail.com' }
    aasm_state { 'unconfirmed' }

    factory :confirmed_mailing_list_entity do
      aasm_state { 'confirmed' }
    end

    factory :archived_mailing_list_entity do
      aasm_state { 'archived' }
    end
  end
end
