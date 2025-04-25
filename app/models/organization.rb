class Organization < ApplicationRecord
  NAME_REGEX = /\A[a-zA-Z0-9\s'-]*\z/
  NAME_MESSAGE = "only allows letters, numbers, spaces, hyphens, and apostrophes"

  validates :name, length: { in: 2..100 }, format: { with: NAME_REGEX, message: NAME_MESSAGE }
  validates :is_active, inclusion: { in: [ true, false ] }
end
