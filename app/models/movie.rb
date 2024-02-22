class Movie < ApplicationRecord
  before_destroy :check_bookmarks
  has_many :bookmarks

  # Validations
  validates :title, :overview, presence: true
  validates :title, uniqueness: true

  private

  def check_bookmarks
    Bookmark.where(movie: self).empty?
  end
end
