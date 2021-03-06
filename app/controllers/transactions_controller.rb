# Controller to transactions entities
class TransactionsController < ApplicationController
  before_action :set_personality_category
  before_action :set_transaction, only: %i[edit update destroy]
  before_action :require_same_category, only: %i[edit update destroy]

  def new
    @transaction = Transaction.new
    @transaction.notes.build
  end

  def create
    create_transaction_params = transaction_params
    create_transaction_params[:amount_cents] = (transaction_params[:amount_cents].to_f * 100).to_i
    @transaction = Transaction.new(create_transaction_params)
    @category.transactions << @transaction
    if @transaction.save
      redirect_to [@personality, @category]
    else
      render 'new'
    end
  end

  def edit; end

  def update
    update_transaction_params = transaction_params
    update_transaction_params[:amount_cents] = (transaction_params[:amount_cents].to_f * 100).to_i
    if @transaction.update(update_transaction_params)
      redirect_to [@personality, @category]
    else
      render 'edit'
    end
  end

  def destroy
    @transaction.destroy
    redirect_to [@personality, @category]
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
    params.require(:transaction).permit(:withdrawal, :amount_cents, :important,
                                        notes_attributes: Note.attribute_names.map(&:to_sym).push(:_destroy))
  end

  def require_same_category
    return unless @category != @transaction.category

    redirect_to [@personality, @category]
  end
end
