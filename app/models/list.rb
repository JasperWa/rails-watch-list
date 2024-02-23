class List < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :movies, through: :bookmarks
  has_many :reviews, dependent: :destroy
  has_one_attached :photo

  # Validations
  validates :name, uniqueness: true
  validates :name, presence: true
  validate :photo_presence # Customer validation for photos

  private

  # Validates the presence and file type of a photo
  def photo_presence
    if photo.attached?
      unless photo.content_type.in?(%w[image/jpeg image/png image/gif])
        errors.add(:photo, 'must be a JPEG, PNG, or GIF')
      end
    else
      errors.add(:photo, 'must be attached')
    end
  end
end
