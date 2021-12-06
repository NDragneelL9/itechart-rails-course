require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe 'UserPersonalities', type: :request do
  # rubocop:enable Metrics/BlockLength
  before do
    User.create(email: 'test@test.com', password: 'password')
    user = User.first
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
      user = User.first
      personality = UserPersonality.create(name: 'GrandPa', user: user)

      get user_personality_path(personality)
      expect(response.body).to include 'GrandPa'
      expect(response).to have_http_status(200)
    end

    it 'should show view edit template' do
      user = User.first
      personality = UserPersonality.create(name: 'GrandPa', user: user)

      get edit_user_personality_path(personality)
      expect(response.body).to include 'Update personality'
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST/PUT/PATCH routes tests' do
    it 'create userpersonality' do
      post user_personalities_path, params: { user_personality: { name: 'GrandPa' } }

      expect(response).to have_http_status(302)
    end

    it 'update userpersonality' do
      user = User.first
      personality = UserPersonality.create(name: 'GrandPa', user: user)
      newName = 'NewPerson'
      patch user_personality_path(personality), params: { user_personality: { name: newName } }
      expect(response).to have_http_status(302)
      follow_redirect!

      expect(response.body).to include newName
      expect(response).to have_http_status(200)
    end

    it 'delete userpersonality' do
      user = User.first
      personality1 = UserPersonality.create(name: 'GrandPa', user: user)
      personality2 = UserPersonality.create(name: 'NewPerson', user: user)
      delete user_personality_path(personality1)
      expect(response).to have_http_status(302)
      follow_redirect!

      expect(response.body).to_not include 'GrandPa'
      expect(response).to have_http_status(200)
    end
  end
end
