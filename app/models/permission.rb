class Permission < ApplicationRecord
  has_many :roles_permissions
  has_many :roles, through: :roles_permissions

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: { scope: :scope }
  validates :description, presence: true, length: { maximum: 100 }
  validates :scope, presence: true, inclusion: { in: %w[user organization project], message: "%{value} is not a valid scope" }
end
