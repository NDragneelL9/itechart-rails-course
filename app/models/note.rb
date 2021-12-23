class Note < ApplicationRecord
  belongs_to(:tranzaction, foreign_key: 'transaction_id', class_name: 'Transaction', inverse_of: false, optional: true)
  before_validation { self.description = description.strip }
  validates :description, presence: true
end
