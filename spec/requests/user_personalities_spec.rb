require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe 'UserPersonalities', type: :request do
  # rubocop:enable Metrics/BlockLength
  let(:user) { FactoryGirl.create(:user) }
  let(:personality) { FactoryGirl.create(:user_personality, user: user) }
  before do
    sign_in user
  end

  describe 'GET routes tests' do
    it 'should show view to create personality' do
      get new_user_personality_path
      expect(response.body).to include 'Create personality'
      expect(response).to have_http_status(200)
    end

    it 'should show index template' do
      get user_personalities_path
      expect(response.body).to include 'Choose your personality'
      expect(response).to have_http_status(200)
    end

    it 'should show view show template' do
      get user_personality_path(personality)
      expect(response.body).to include 'Son'
      expect(response).to have_http_status(200)
    end

    it 'should show view edit template' do
      get edit_user_personality_path(personality)
      expect(response.body).to include 'Update personality'
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST/PUT/PATCH routes tests' do
    it 'create user_personality' do
      post user_personalities_path, params: { user_personality: { name: 'Son' } }

      expect(response).to have_http_status(302)
    end

    it 'update user_personality' do
      new_name = 'NewPerson'
      patch user_personality_path(personality), params: { user_personality: { name: new_name } }
      expect(response).to have_http_status(302)
      follow_redirect!

      expect(response.body).to include new_name
      expect(response).to have_http_status(200)
    end

    it 'delete user_personality' do
      personality1 = FactoryGirl.create(:user_personality, user: user)
      personality2 = FactoryGirl.create(:user_personality, user: user)
      delete user_personality_path(personality1)
      expect(response).to have_http_status(302)
      follow_redirect!

      expect(response.body).to     include personality2.name
      expect(response.body).to_not include personality1.name
      expect(response).to have_http_status(200)
    end
  end
end
