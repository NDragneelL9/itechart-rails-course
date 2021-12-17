class Transaction < ApplicationRecord
  belongs_to :category
  validates :amount_cents, numericality: { only_integer: true }
  before_update :rollback_update_action
  before_destroy :rollback_update_action
  after_save :update_category_amount

  private

  def update_category_amount
    @amount_after_transaction = if withdrawal
                                  category.amount_cents - amount_cents
                                else
                                  category.amount_cents + amount_cents
                                end
    category.update(amount_cents: @amount_after_transaction)
  end

  def rollback_update_action
    @amount_after_rollback = if withdrawal_was
                               category.amount_cents + amount_cents_was
                             else
                               category.amount_cents - amount_cents_was
                             end
    category.update(amount_cents: @amount_after_rollback)
  end
end
