FactoryBot.define do
  factory :mailer do
    subject { 'Test Mailer' }
    aasm_state { 'draft' }

    factory :published_mailer do
      published_at { DateTime.now - 1.day }
      aasm_state { 'published' }
    end
  end
end
