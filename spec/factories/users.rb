FactoryBot.define do
  factory :user do
    email_address { 'user@example.com' }
    password { 'P@ssw0rd!!' }
    aasm_state { 'unverified' }
    mailing_list { false }

    factory :active_user do
      aasm_state { 'active' }
    end
  end
end
