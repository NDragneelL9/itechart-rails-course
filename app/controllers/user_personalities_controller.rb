# Controller to user_personalities
class UserPersonalitiesController < ApplicationController
  before_action :set_personality, only: %i[show edit update destroy]
  before_action :require_same_user, only: %i[show edit update destroy]

  def new
    @personality = UserPersonality.new
  end

  def create
    @personality = UserPersonality.new(personality_params)
    @personality.user_id = current_user.id
    if @personality.save
      redirect_to @personality
    else
      render 'new'
    end
  end

  def index
    @personalities = current_user.user_personalities
  end

  def show
    @categories = Category.all.where(user_personality_id: @personality.id)
  end

  def edit; end

  def update
    if @personality.update(personality_params)
      redirect_to @personality
    else
      render 'edit'
    end
  end

  def destroy
    @personality.destroy
    redirect_to user_personalities_path
  end

  private

  def set_personality
    @personality = UserPersonality.find(params[:id])
  end

  def personality_params
    params.require(:user_personality).permit(:name)
  end

  def require_same_user
    return unless current_user != @personality.user

    redirect_to user_personalities_path
  end
end
