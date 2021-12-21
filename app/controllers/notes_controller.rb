class NotesController < ApplicationController
  before_action :set_attr
  before_action :set_note, only: %i[edit update destroy]
  # TODO: check if underline is needed
  # before_action :require_same_transaction, only: %i[show edit update destroy]

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(description: note_params[:description], transaction_id: @transaction.id)
    if @note.save
      # TODO: Add toasts success notifications
      redirect_to [@personality, @category]
    else
      render 'new'
    end
  end

  def show; end

  def edit; end

  def update
    if @note.update(description: note_params[:description], transaction_id: @transaction.id)
      # TODO: Add toasts success notifications
      redirect_to [@personality, @category]
    else
      render 'edit'
    end
  end

  def destroy
    @note.destroy
    redirect_to [@personality, @category]
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def set_attr
    @transaction = Transaction.find(params[:transaction_id])
    @category = Category.find(params[:category_id])
    @personality = UserPersonality.find(params[:user_personality_id])
  end

  def note_params
    params.require(:note).permit(:description)
  end
end
