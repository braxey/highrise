class OrganizationInvitation < ApplicationRecord
  belongs_to :organization
  belongs_to :role, optional: true
  belongs_to :invited_by, class_name: "User"

  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validates :status, inclusion: { in: %w[pending accepted denied] }
  validates :organization_id, uniqueness: { scope: :email_address, message: "has already been invited" }

  scope :pending, -> { where(status: "pending") }

  before_validation :generate_token, on: :create
  before_validation :regenerate_token, on: :update, if: :status_changed_to_pending?

  private
    def generate_token
      self.token ||= SecureRandom.urlsafe_base64(32)
    end

    def regenerate_token
      self.token = SecureRandom.urlsafe_base64(32)
    end

    def status_changed_to_pending?
      status_changed? && status == "pending"
    end
end
