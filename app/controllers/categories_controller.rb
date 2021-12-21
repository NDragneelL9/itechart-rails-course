# Controller to categories entities
class CategoriesController < ApplicationController
  before_action :set_personality
  before_action :set_category, only: %i[show edit update destroy]
  before_action :require_same_personality, only: %i[show edit update destroy]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(name: category_params[:name], user_personality: @personality)
    if @category.save
      # TODO: Add toasts success notifications
      redirect_to @personality
    else
      render 'new'
    end
  end

  def show
    last_month = Time.zone.now.last_month
    @transactions = @category.transactions.where('created_at > ? or updated_at > ?', last_month, last_month)
  end

  def edit; end

  def update
    if @category.update(name: category_params[:name], user_personality: @personality)
      # TODO: Add toasts success notifications
      redirect_to @personality
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to @personality
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def set_personality
    @personality = UserPersonality.find(params[:user_personality_id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def require_same_personality
    return unless @personality != @category.user_personality

    # TODO: Add toasts that u cant perform actions with not yours categories
    redirect_to @personality
  end
end
