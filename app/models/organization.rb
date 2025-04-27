class Organization < ApplicationRecord
  trim_strings_only :name
  NAME_REGEX = /\A[a-zA-Z0-9\s',-]*\z/
  NAME_MESSAGE = "only allows letters, numbers, spaces, hyphens, and apostrophes"

  has_many :organization_memberships, dependent: :destroy
  has_many :users, through: :organization_memberships
  has_many :organization_invitations, dependent: :destroy

  validates :name, length: { in: 2..100 }, format: { with: NAME_REGEX, message: NAME_MESSAGE }
  validates :is_active, inclusion: { in: [ true, false ] }
end
