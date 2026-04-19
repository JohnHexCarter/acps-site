require 'rails_helper'

RSpec.describe DashObject, type: :model do
  let(:subject) { create(:dash_object) }

  describe 'validations' do
    it 'requires a name to be valid' do
      subject.name = nil

      expect(subject).not_to be_valid
    end

    it 'requires a namespace to be valid' do
      subject.namespace = nil

      expect(subject).not_to be_valid
    end

    it 'requires a unique namespace to be valid' do
      new_subject = build(:dash_object, namespace: subject.namespace)

      expect(new_subject).not_to be_valid
    end
  end
end
