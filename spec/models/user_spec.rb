require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(email: 'test@test.com', password: 'password') }

  context 'validation tests' do
    it 'ensures email presence' do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it 'ensures password presence' do
      subject.password = nil
      expect(subject).to_not be_valid
    end

    it 'ensures email valid' do
      subject.email = 'test.com'
      expect(subject).to_not be_valid
    end

    it 'ensures password valid' do
      subject.password = 'test'
      expect(subject).to_not be_valid
    end

    it 'should be valid' do
      expect(subject).to be_valid
    end
  end
end
