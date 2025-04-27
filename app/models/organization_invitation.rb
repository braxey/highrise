class OrganizationInvitation < ApplicationRecord
  belongs_to :organization
  belongs_to :role, optional: true
  belongs_to :invited_by, class_name: "User"

  has_secure_token :token

  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validates :status, inclusion: { in: %w[pending accepted denied] }
  validates :organization_id, uniqueness: { scope: :email_address, message: "has already been invited" }

  scope :pending, -> { where(status: "pending") }

  after_save_commit :send_invitation, if: :status_is_pending?

  private
    def send_invitation
      OrganizationInvitationsMailer.with(organization_invitation: self).notify_invited.deliver_later
    end

    def status_is_pending?
      status == "pending"
    end
end
