class OrganizationMembership < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :role, optional: true

  validates :organization_id, uniqueness: { scope: :user_id }
end
