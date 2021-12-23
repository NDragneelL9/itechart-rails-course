require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe 'Categories', type: :request do
  # rubocop:enable Metrics/BlockLength
  let(:user) { FactoryGirl.create(:user) }
  let(:personality) { FactoryGirl.create(:user_personality, user: user) }
  let(:category) { FactoryGirl.create(:category, user_personality: personality) }

  before do
    sign_in user
  end

  describe 'GET routes tests for categories' do
    it 'should show new template' do
      get url_for([personality])
      expect(response.body).to include 'Create category'
      expect(response).to have_http_status(200)
    end

    it 'should show show template' do
      get url_for([personality, category])
      expect(response.body).to include 'Food'
      expect(response).to have_http_status(200)
    end

    it 'should show edit template' do
      get url_for([:edit, personality, category])
      expect(response.body).to include 'Update category'
      expect(response).to have_http_status(200)
    end
  end

  describe 'positive POST/PATCH/DELETE routes tests for categories' do
    it 'should create category' do
      name = 'Food'
      post url_for([personality, Category.new]), params: { category: { name: name } }
      expect(Category.last.name).to eq(name)
      expect(response).to have_http_status(302)
    end

    it 'should update category' do
      new_name = 'Travel'
      patch url_for([personality, category]), params: { category: { name: new_name } }
      category_new_name = Category.find(category.id).name
      expect(category_new_name).to eq(new_name)
      expect(response).to have_http_status(302)
    end

    it 'should delete category' do
      delete url_for([personality, category])
      expect(response).to have_http_status(302)
      expect { Category.find(category.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'negative POST/PATCH/DELETE routes tests for categories' do
    it 'should render new template if params werent correct' do
      name = ''
      post url_for([personality, Category.new]), params: { category: { name: name } }
      expect(response.body).to include 'Create category'
      expect(response).to have_http_status(200)
    end

    it 'should render edit template if params werent correct' do
      new_name = ''
      patch url_for([personality, category]), params: { category: { name: new_name } }
      expect(response.body).to include 'Update category'
      expect(response).to have_http_status(200)
    end

    it 'should restrict access to act with unfamiliar categories' do
      personality2 = FactoryGirl.create(:user_personality, user: user)
      get url_for([personality2, category])
      expect(response).to have_http_status(302)
    end
  end

  describe 'error handler tests' do
    it 'should handle record not found error' do
      fake_category_id = 0
      get user_personality_category_path(personality, fake_category_id)
      expect(response.body).to include "Something wen't wrong"
    end

    it 'should handle delete restriction error' do
      category_with_transactions = FactoryGirl.create(:category_with_transactions)
      category_to_destroy = Category.find(category_with_transactions.id)
      expect { category_to_destroy.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
    end
  end
end
