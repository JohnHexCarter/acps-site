FactoryBot.define do
  factory :page do
    name { 'Test Page' }
    content { '<p>Test Content</p>' }
    aasm_state { 'draft' }
    top_nav { 'Test' }
    display_order { 1 }

    factory :published_page do
      aasm_state { 'published' }
    end

    factory :archived_page do
      aasm_state { 'archived' }
    end
  end
end
