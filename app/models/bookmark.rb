class Bookmark < ApplicationRecord
  belongs_to :movie
  belongs_to :list

  # Validations
  validates :movie_id, :list_id, presence: true
  validates :movie_id, uniqueness: { scope: [:list_id] }
  validates :comment, length: { minimum: 6 }
end
