require 'rails_helper'

RSpec.describe 'UserPersonalities', type: :request do
  before do
    user = User.create(email: "test@test.com", password: "password")
    sign_in(user)
  end

  describe 'GET routes tests' do
    it 'should show view to create personality' do
      get new_user_personality_path
      expect(response.body).to include 'Create personality'
    end

    it 'should show index template' do
      get user_personalities_path
      expect(response.body).to include 'Choose your personality'
    end

    it 'should show view show template' do
      # FIXME: redirects to user_personalities_path instead of render :show template
      personality = UserPersonality.create!(name: "GrandPa", user: User.create(email: "test@test.com", password: "password"))
      get user_personality_path(personality.id)

      # follow_redirect!
      expect(response).to have_http_status(200)
      expect(response.body).to include 'Edit'
    end
  end

  describe 'Post method' do
    it 'create userpersonality' do
      get new_user_personality_path
      expect(response).to have_http_status(200)

      post user_personalities_path, params: { user_personality: { name: "GrandPa" } }
      expect(response).to have_http_status(302)
    end
  end

end