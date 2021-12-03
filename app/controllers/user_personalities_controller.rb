class UserPersonalitiesController < ApplicationController

  before_action :set_personality, only: [:show, :edit, :update, :destroy]

  def new
    @personality = UserPersonality.new
  end

  def create
    @personality = UserPersonality.new(personality_params)
    @personality.user_id = current_user.id
    if @personality.save
      flash[:notice] = "Personality was created successfully"
      redirect_to @personality
    else
      render 'new'
    end
  end

  def index
    @personalities = current_user.user_personalities
  end

  def show
  end

  def edit    
  end

  def update
    if @personality.update(personality_params)
      flash[:notice] = "Personality was updated successfully"
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

end
