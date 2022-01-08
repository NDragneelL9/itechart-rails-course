require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:personality) { FactoryGirl.create(:user_personality, user: user) }

  before do
    sign_in user
  end

  describe 'GET /index' do
    it 'GET root page after authentication' do
      get root_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /user_personalities/:id/graphics' do
    it 'GET root page after authentication' do
      get user_personality_graphics_path(personality)
      expect(response).to have_http_status(200)
    end
  end
end
