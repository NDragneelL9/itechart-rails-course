require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe 'Categories', type: :request do
  # rubocop:enable Metrics/BlockLength
  # NOTE: before do section might be refactored afterwards
  let(:user) { FactoryGirl.create(:user) }
  let(:personality) { FactoryGirl.create(:user_personality, user: user) }
  let(:category) { FactoryGirl.create(:category, user_personality: personality) }

  before do
    sign_in user
  end

  describe 'GET routes tests' do
    it 'should show view to create personality' do
      get new_user_personality_category_path(personality)
      expect(response.body).to include 'Create category'
      expect(response).to have_http_status(200)
    end

    it 'should show view show template' do
      get user_personality_category_path(personality, category)
      expect(response.body).to include 'Food'
      expect(response).to have_http_status(200)
    end

    it 'should show view edit template' do
      get edit_user_personality_category_path(personality, category)
      expect(response.body).to include 'Update category'
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST/PUT/PATCH routes tests' do
    it 'create category' do
      post user_personality_categories_path(personality), params: { category: { name: 'Food' } }
      expect(response).to have_http_status(302)
    end

    it 'update category' do
      new_name = 'Travel'
      patch user_personality_category_path(personality, category), params: { category: { name: new_name } }
      expect(response).to have_http_status(302)
      follow_redirect!

      expect(response.body).to include new_name
      expect(response).to have_http_status(200)
    end

    it 'delete category' do
      category1 = FactoryGirl.create(:category, user_personality: personality)
      category2 = FactoryGirl.create(:category, user_personality: personality)

      delete user_personality_category_path(personality, category1)
      expect(response).to have_http_status(302)
      follow_redirect!

      expect(response.body).to     include category2.name
      expect(response.body).to_not include category1.name
      expect(response).to have_http_status(200)
    end
  end
end
