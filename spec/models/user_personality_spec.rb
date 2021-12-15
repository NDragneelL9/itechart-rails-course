require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe UserPersonality, type: :model do
  # rubocop:enable Metrics/BlockLength
  subject { FactoryGirl.create(:user_personality) }

  context 'validation tests' do
    it 'ensures name presence' do
      subject.name = ''
      expect(subject).to_not be_valid
    end

    it 'ensures name length more then 3' do
      subject.name = 'na'
      expect(subject).to_not be_valid
    end

    it 'ensures name length less then 14' do
      subject.name = 'a' * 15
      expect(subject).to_not be_valid
    end

    it 'name should be unique' do
      personality = FactoryGirl.build(:user_personality, name: subject.name, user: subject.user).save
      expect(personality).to eq(false)
    end

    it 'should be valid' do
      expect(subject).to be_valid
    end
  end

  context 'Associations test' do
    it 'should have user' do
      subject.user = nil
      expect(subject).to_not be_valid
    end

    it 'Cant delete personality, if it has childs' do
      personality = FactoryGirl.create(:user_personality_with_categories)
      expect { personality.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
    end
  end
end
