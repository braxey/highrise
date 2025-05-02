class Role < ApplicationRecord
  has_many :users
  has_many :organization_memberships
  has_many :organization_invitations

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: { scope: :scope }
  validates :scope, presence: true, inclusion: { in: %w[user organization project], message: "%{value} is not a valid scope" }

  def humanize
    name.humanize
  end
end
