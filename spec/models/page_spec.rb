require 'rails_helper'

RSpec.describe Page, type: :model do
  let(:subject) { build(:page) }

  describe 'validations' do
    it 'requires a name to be valid' do
      subject.name = nil

      expect(subject).not_to be_valid
    end

    it 'requires a unique name to be valid' do
      page = create(:page)

      subject.name = page.name
      expect(subject).not_to be_valid
    end

    it 'requires content to be valid' do
      subject.content = nil

      expect(subject).not_to be_valid
    end

    it 'requires aasm_state to be valid' do
      subject.aasm_state = nil

      expect(subject).not_to be_valid
    end

    it 'requires top_nav to be valid' do
      subject.top_nav = nil

      expect(subject).not_to be_valid
    end

    it 'requires display_order to not be zero' do
      subject.display_order = 0

      expect(subject).not_to be_valid
    end

    it 'requires display_order to be non-negative' do
      subject.display_order = -1

      expect(subject).not_to be_valid
    end

    it 'requires display_order to be present' do
      subject.display_order = nil

      expect(subject).not_to be_valid
    end
  end
end
