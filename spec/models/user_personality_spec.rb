require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe UserPersonality, type: :model do
  # rubocop:enable Metrics/BlockLength
  subject { UserPersonality.new(name: 'GrandPa', user: User.create(email: 'test@test.com', password: 'password')) }

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
      subject.save
      personality = UserPersonality.new(name: 'GrandPa', user: subject.user).save
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

    it 'ensures last user personality remains' do
      destroy_action = subject.user.user_personalities.last.destroy
      expect(destroy_action).to eq(nil)
    end
  end
end
