# Controller to transactions entities
class TransactionController < ApplicationController
  before_action :set_transaction, only: %i[show edit update destroy]
  before_action :require_same_category, only: %i[show edit update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new() # TODO: add params here
    if @transaction.save
      # TODO: Add toasts success notifications
      redirect_to # TODO: insert the redirection to transaction show page
    else
      render 'new'
    end
  end

  def show; end

  def edit; end

  def update
    if @transaction.update() # TODO: add params here
      # TODO: Add toasts success notifications
      redirect_to # TODO: insert the redirection to transaction show page
    else
      render 'edit'
    end
  end

  def destroy
    @transaction.destroy
    redirect_to # TODO: insert the redirection to transactions index page
  end

  private

  def set_category
    @transaction = Transaction.find(params[:id])
  end

  def category_params
    params.require(:transaction).permit(:withdrawal, :amount_cents)
  end

  def require_same_personality
    return unless current_category != @transaction.category

    # TODO: Add toasts that u cant perform actions with not yours transactions
    redirect_to # TODO: insert the redirection to transactions index page
  end

  def record_not_found
    redirect_to # TODO: insert the redirection to transactions index page
  end
end
