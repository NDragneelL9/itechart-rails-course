# Controller to transactions entities
class TransactionsController < ApplicationController
  before_action :set_personality_category
  before_action :set_transaction, only: %i[edit update destroy]
  before_action :require_same_category, only: %i[edit update destroy]

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(withdrawal: transaction_params[:withdrawal],
                                   amount_cents: (transaction_params[:amount_cents].to_f * 100).to_i,
                                   category_id: @category.id)
    if @transaction.save
      # TODO: Add toasts success notifications
      redirect_to user_personality_category_path(@personality, @category)
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @transaction.update(withdrawal: transaction_params[:withdrawal],
                           amount_cents: (transaction_params[:amount_cents].to_f * 100).to_i,
                           category_id: @category.id)
      # TODO: Add toasts success notifications
      redirect_to user_personality_category_path(@personality, @category)
    else
      render 'edit'
    end
  end

  def destroy
    @transaction.destroy
    redirect_to user_personality_category_path(@personality, @category)
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def set_personality_category
    @personality = UserPersonality.find(params[:user_personality_id])
    @category = Category.find(params[:category_id])
  end

  def transaction_params
    params.require(:transaction).permit(:withdrawal, :amount_cents)
  end

  def require_same_category
    return unless @category != @transaction.category

    # TODO: Add toasts that u cant perform actions with not yours transactions
    redirect_to user_personality_category_path(@personality, @category)
  end
end
