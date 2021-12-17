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
      get new_user_personality_category_path(personality)
      expect(response.body).to include 'Create category'
      expect(response).to have_http_status(200)
    end

    it 'should show show template' do
      get user_personality_category_path(personality, category)
      expect(response.body).to include 'Food'
      expect(response).to have_http_status(200)
    end

    it 'should show edit template' do
      get edit_user_personality_category_path(personality, category)
      expect(response.body).to include 'Update category'
      expect(response).to have_http_status(200)
    end
  end

  describe 'positive POST/PATCH/DELETE routes tests for categories' do
    it 'should create category' do
      name = 'Food'
      post user_personality_categories_path(personality), params: { category: { name: name } }
      expect(Category.last.name).to eq(name)
      expect(response).to have_http_status(302)
    end

    it 'should update category' do
      new_name = 'Travel'
      patch user_personality_category_path(personality, category), params: { category: { name: new_name } }
      category_new_name = Category.find(category.id).name
      expect(category_new_name).to eq(new_name)
      expect(response).to have_http_status(302)
    end

    it 'should delete category' do
      delete user_personality_category_path(personality, category)
      expect(response).to have_http_status(302)
      expect { Category.find(category.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'negative POST/PATCH/DELETE routes tests for categories' do
    it 'should render new template if params werent correct' do
      name = ''
      post user_personality_categories_path(personality), params: { category: { name: name } }
      expect(response.body).to include 'Create category'
      expect(response).to have_http_status(200)
    end

    it 'should render edit template if params werent correct' do
      new_name = ''
      patch user_personality_category_path(personality, category), params: { category: { name: new_name } }
      expect(response.body).to include 'Update category'
      expect(response).to have_http_status(200)
    end

    it 'should restrict access to act with unfamiliar categories' do
      personality2 = FactoryGirl.create(:user_personality, user: user)
      get user_personality_category_path(personality2, category)
      expect(response).to have_http_status(302)
    end

    it 'should handle record not found error' do
      fake_category_id = 0
      get user_personality_category_path(personality, fake_category_id)
      expect(response).to have_http_status(302)
    end
  end
end
