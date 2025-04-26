class Role < ApplicationRecord
  has_many :organization_memberships
  has_many :organization_invitations

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: { scope: :scope }
  validates :scope, presence: true, inclusion: { in: %w[global organization project], message: "%{value} is not a valid scope" }
end
