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
      get new_user_personality_category_transaction_path(personality, category)
      expect(response.body).to include 'Create transaction'
      expect(response).to have_http_status(200)
    end

    it 'should show edit template' do
      get edit_user_personality_category_transaction_path(personality, category, transaction)
      expect(response.body).to include 'Update transaction'
      expect(response).to have_http_status(200)
    end
  end

  describe 'positive POST/PATCH/DELETE routes tests for transactions' do
    it 'should create transaction' do
      amount_cents = 150
      post user_personality_category_transactions_path(personality, category),
           params: { transaction: { withdrawal: true, amount_cents: amount_cents } }
      expect(Transaction.last.amount_cents).to eq(amount_cents)
      expect(response).to have_http_status(302)
    end

    it 'should update transaction' do
      new_amount_cents = 400
      patch user_personality_category_transaction_path(personality, category, transaction),
            params: { transaction: { amount_cents: new_amount_cents } }
      transaction_new_amount_cents = Transaction.find(transaction.id).amount_cents
      expect(transaction_new_amount_cents).to eq(new_amount_cents)
      expect(response).to have_http_status(302)
    end

    it 'should delete transaction' do
      delete user_personality_category_transaction_path(personality, category, transaction)
      expect(response).to have_http_status(302)
      expect { Transaction.find(transaction.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  # rubocop:disable Metrics/BlockLength
  describe 'negative POST/PATCH/DELETE routes tests for transactions' do
    # rubocop:enable Metrics/BlockLength
    it 'should render new template if params werent correct' do
      new_amount_cents = ''
      post user_personality_category_transactions_path(personality, category),
           params: { transaction: { withdrawal: true, amount_cents: new_amount_cents } }
      expect(response.body).to include 'Create transaction'
      expect(response).to have_http_status(200)
    end

    it 'should render edit template if params werent correct' do
      new_amount_cents = ''
      patch user_personality_category_transaction_path(personality, category, transaction),
            params: { transaction: { amount_cents: new_amount_cents } }
      expect(response.body).to include 'Update transaction'
      expect(response).to have_http_status(200)
    end

    it 'should restrict access to act with unfamiliar transactions' do
      category2 = FactoryGirl.create(:category)
      transactions2 = FactoryGirl.create(:transaction, category: category2)
      get edit_user_personality_category_transaction_path(personality, category, transactions2)
      expect(response).to have_http_status(302)
    end

    it 'should handle record not found error' do
      fake_transaction_id = 0
      new_amount_cents = 400
      patch user_personality_category_transaction_path(personality, category, fake_transaction_id),
            params: { transaction: { amount_cents: new_amount_cents } }
      expect(response.body).to include "Something wen't wrong"
    end
  end
end
