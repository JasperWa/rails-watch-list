class Review < ApplicationRecord
  belongs_to :list

  # Validation
  validates :list_id, :content, :rating, presence: true
  validates :content, length: { minimum: 6 }
  validates :rating, numericality: { only_integer: true }
  validates :rating, comparison: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
end
