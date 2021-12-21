require 'rails_helper'
RSpec.describe Transaction, type: :model do
  amount_cents = 250
  withdrawal = false
  subject { FactoryGirl.create(:transaction, withdrawal: withdrawal, amount_cents: amount_cents) }

  context 'Callbacks tests' do
    it 'ensures update_category_amount works' do
      expect(subject.category.amount_cents).to eq(amount_cents)
    end

    it 'ensures rollback_update_action works' do
      category = subject.category
      subject.destroy
      expect(category.amount_cents).to eq(0)
    end
  end

  context 'Associations test' do
    it 'should have category' do
      subject.category = nil
      expect(subject).to_not be_valid
    end
  end
end
