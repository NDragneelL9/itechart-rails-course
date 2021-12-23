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
      get url_for([personality])
      expect(response.body).to include personality.name
      expect(response).to have_http_status(200)
    end

    it 'should show edit template' do
      get url_for([:edit, personality])
      expect(response.body).to include 'Update personality'
      expect(response).to have_http_status(200)
    end
  end

  describe 'positive POST/PATCH/DELETE routes tests for personalities' do
    it 'should create personality' do
      name = 'Son'
      post user_personalities_path, params: { user_personality: { name: name } }
      expect(UserPersonality.last.name).to eq(name)
      expect(response).to have_http_status(302)
    end

    it 'should update personality' do
      new_name = 'NewPerson'
      patch url_for([personality]), params: { user_personality: { name: new_name } }
      personality_new_name = UserPersonality.find(personality.id).name
      expect(personality_new_name).to eq(new_name)
      expect(response).to have_http_status(302)
    end

    it 'should delete personality' do
      delete url_for([personality])
      expect(response).to have_http_status(302)
      expect { UserPersonality.find(personality.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'negative POST/PATCH/DELETE routes tests for personalities' do
    it 'should render new template if params werent correct' do
      name = ''
      post user_personalities_path, params: { user_personality: { name: name } }
      expect(response.body).to include 'Create personality'
      expect(response).to have_http_status(200)
    end

    it 'should render edit template if params werent correct' do
      new_name = ''
      patch url_for([personality]), params: { user_personality: { name: new_name } }
      expect(response.body).to include 'Update personality'
      expect(response).to have_http_status(200)
    end

    it 'should restrict access to act with unfamiliar personalities' do
      user2 = FactoryGirl.create(:user)
      personality2 = FactoryGirl.create(:user_personality, user: user2)
      get url_for([personality2])
      expect(response).to have_http_status(302)
    end
  end

  describe 'error handler tests' do
    it 'should handle record not found error' do
      fake_personality_id = 0
      get user_personality_path(fake_personality_id)
      expect(response.body).to include "Something wen't wrong"
    end

    it 'should handle delete restriction error' do
      personality_with_transactions = FactoryGirl.create(:user_personality_with_categories_transactions)
      personality_to_destroy = UserPersonality.find(personality_with_transactions.id)
      expect { personality_to_destroy.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
    end
  end
end
