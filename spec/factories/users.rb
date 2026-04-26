FactoryBot.define do
  factory :user do
    email_address { 'user@example.com' }
    password { 'P@ssw0rd!!' }
    aasm_state { 'unverified' }
    mailing_list { false }

    factory :active_user do
      aasm_state { 'active' }
    end

    factory :suspended_user do
      aasm_state { 'suspended' }
    end

    factory :banned_user do
      aasm_state { 'banned' }
    end
  end
end
