class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :current_personality

  def current_personality
    @current_personality = UserPersonality.find(params[:user_personality_id])
  end
end
