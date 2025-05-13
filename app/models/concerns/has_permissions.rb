# frozen_string_literal: true

module HasPermissions
  extend ActiveSupport::Concern

  included do
    belongs_to :role
  end

  def can?(permission_name)
    role&.permissions&.exists?(name: permission_name.to_s) || false
  end

  def cannot?(permission_name)
    !can?(permission_name)
  end

  def can_all?(*permission_names)
    names = permission_names.flatten.map(&:to_s)
    return false if names.empty? || role.nil?

    (role.permissions.where(name: names).pluck(:name).uniq.sort == names.uniq.sort)
  end

  def can_any?(*permission_names)
    names = permission_names.flatten.map(&:to_s)
    return false if names.empty? || role.nil?

    role.permissions.where(name: names).exists?
  end
end
