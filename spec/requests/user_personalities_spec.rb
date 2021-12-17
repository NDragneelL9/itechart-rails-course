require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe 'UserPersonalities', type: :request do
  # rubocop:enable Metrics/BlockLength
  let(:user) { FactoryGirl.create(:user) }
  let(:personality) { FactoryGirl.create(:user_personality, user: user) }
  before do
    sign_in user
  end

  describe 'GET routes tests for personalities' do
    it 'should show new template' do
      get new_user_personality_path
      expect(response.body).to include 'Create personality'
      expect(response).to have_http_status(200)
    end

    it 'should show index template' do
      get user_personalities_path
      expect(response.body).to include 'Choose your personality'
      expect(response).to have_http_status(200)
    end

    it 'should show show template' do
      get user_personality_path(personality)
      expect(response.body).to include personality.name
      expect(response).to have_http_status(200)
    end

    it 'should show edit template' do
      get edit_user_personality_path(personality)
      expect(response.body).to include 'Update personality'
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST/PATCH/DELETE routes tests for personalities' do
    it 'should create personality' do
      name = 'Son'
      post user_personalities_path, params: { user_personality: { name: name } }
      expect(UserPersonality.last.name).to eq(name)
      expect(response).to have_http_status(302)
    end

    it 'should update personality' do
      new_name = 'NewPerson'
      patch user_personality_path(personality), params: { user_personality: { name: new_name } }
      personality_new_name = UserPersonality.find(personality.id).name
      expect(personality_new_name).to eq(new_name)
      expect(response).to have_http_status(302)
    end

    it 'should delete personality' do
      delete user_personality_path(personality)
      expect(response).to have_http_status(302)
      expect { UserPersonality.find(personality.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
