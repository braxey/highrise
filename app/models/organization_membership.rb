class OrganizationMembership < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :role

  validates :organization_id, uniqueness: { scope: :user_id }
end
