require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe 'Categories', type: :request do
  # rubocop:enable Metrics/BlockLength
  let(:user) { FactoryGirl.create(:user) }
  let(:personality) { FactoryGirl.create(:user_personality, user: user) }
  let(:category) { FactoryGirl.create(:category, user_personality: personality) }
  let(:transaction) { FactoryGirl.create(:transaction, category: category) }

  before do
    sign_in user
  end

  describe 'GET routes tests for transactions' do
    it 'should show new template' do
      get url_for([personality, category])
      expect(response.body).to include 'Create transaction'
      expect(response).to have_http_status(200)
    end

    it 'should show edit template' do
      get url_for([:edit, personality, category, transaction])
      expect(response.body).to include 'Update transaction'
      expect(response).to have_http_status(200)
    end
  end

  describe 'positive POST/PATCH/DELETE routes tests for transactions' do
    it 'should create transaction' do
      amount_usd = 1.5
      post url_for([personality, category, Transaction.new]),
           params: { transaction: { withdrawal: true, amount_cents: amount_usd } }
      expect(Transaction.last.amount_cents).to eq(amount_usd * 100)
      expect(response).to have_http_status(302)
    end

    it 'should update transaction' do
      new_amount_usd = 4.00
      patch url_for([personality, category, transaction]),
            params: { transaction: { amount_cents: new_amount_usd } }
      transaction_new_amount_cents = Transaction.find(transaction.id).amount_cents
      expect(transaction_new_amount_cents).to eq(new_amount_usd * 100)
      expect(response).to have_http_status(302)
    end

    it 'should delete transaction' do
      delete url_for([personality, category, transaction])
      expect(response).to have_http_status(302)
      expect { Transaction.find(transaction.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'negative POST/PATCH/DELETE routes tests for transactions' do
    it 'should restrict access to act with unfamiliar transactions' do
      category2 = FactoryGirl.create(:category)
      transactions2 = FactoryGirl.create(:transaction, category: category2)
      get url_for([:edit, personality, category, transactions2])
      expect(response).to have_http_status(302)
    end

    it 'should handle record not found error' do
      fake_transaction_id = 0
      new_amount_usd = 4.00
      patch url_for([personality, category, transaction_id: fake_transaction_id]),
            params: { transaction: { amount_cents: new_amount_usd } }
      expect(response.body).to include "Something wen't wrong"
    end
  end
end
