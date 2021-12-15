require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET /index' do
    it 'GET root page after authentication' do
      user = FactoryGirl.create(:user)
      sign_in(user)
      get root_path
      expect(response).to have_http_status(200)
    end
  end
end
