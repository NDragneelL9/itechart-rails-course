require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Category, type: :model do
  # rubocop:enable Metrics/BlockLength
  subject { FactoryGirl.create(:category) }

  context 'Validation tests' do
    it 'ensures name presence' do
      subject.name = ''
      expect(subject).to_not be_valid
    end

    it 'ensures name length more then 3' do
      subject.name = 'fo'
      expect(subject).to_not be_valid
    end

    it 'ensures name length less then 14' do
      subject.name = 'food' * 4
      expect(subject).to_not be_valid
    end

    it 'name should be unique' do
      category = FactoryGirl.build(:category, name: subject.name, user_personality: subject.user_personality).save
      expect(category).to eq(false)
    end

    it 'should be valid' do
      expect(subject).to be_valid
    end
  end

  context 'Associations test' do
    it 'should have user personality' do
      subject.user_personality = nil
      expect(subject).to_not be_valid
    end

    it 'Cant delete category, if it has childs' do
      category = FactoryGirl.create(:category_with_transactions)
      expect { category.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
    end
  end
end
