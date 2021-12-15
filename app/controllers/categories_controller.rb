# Controller to categories entities
class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]
  before_action :require_same_personality, only: %i[show edit update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(name: category_params[:name], user_personality: current_personality)
    if @category.save
      # TODO: Add toasts success notifications
      redirect_to user_personality_path(current_personality)
    else
      render 'new'
    end
  end

  def show; end

  def edit; end

  def update
    if @category.update(name: category_params[:name], user_personality: current_personality)
      # TODO: Add toasts success notifications
      redirect_to user_personality_path(current_personality)
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to user_personality_path(current_personality)
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def require_same_personality
    return unless current_personality != @category.user_personality

    # TODO: Add toasts that u cant perform actions with not yours categories
    redirect_to user_personality_path(current_personality)
  end

  def record_not_found
    redirect_to user_personality_path(current_personality)
  end
end
