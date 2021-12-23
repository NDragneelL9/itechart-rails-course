require 'rails_helper'
RSpec.describe Note, type: :model do
  subject { FactoryGirl.create(:note) }

  context 'Validation tests' do
    it 'ensures description presence' do
      subject.description = ''
      expect(subject).to_not be_valid
    end

    it 'should be valid' do
      expect(subject).to be_valid
    end
  end

  context 'Associations test' do
    it 'should have transaction' do
      subject.tranzaction = nil
      expect(subject).to_not be_valid
    end
  end
end
