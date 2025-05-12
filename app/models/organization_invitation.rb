class OrganizationInvitation < ApplicationRecord
  belongs_to :organization
  belongs_to :role
  belongs_to :invited_by, class_name: "User"
  has_one :notification, as: :notifiable, dependent: :destroy

  has_secure_token :token

  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :token, presence: true, uniqueness: true

  validates :status, inclusion: { in: %w[pending accepted denied] }

  validate :only_one_pending_invite_per_email_per_org
  validate :cannot_invite_existing_org_member

  scope :pending, -> { where(status: "pending") }

  after_save_commit :send_invitation, if: :status_is_pending?

  def link
    "/organizations/#{organization_id}/organization_invitations/#{token}"
  end

  def status_is_pending?
    status == "pending"
  end

  private
    def send_invitation
      OrganizationInvitationsMailer.with(organization_invitation: self).notify_invited.deliver_later
    end

    def only_one_pending_invite_per_email_per_org
      return unless status == "pending"

      existing = OrganizationInvitation.where(
        organization_id: organization_id,
        email_address: email_address,
        status: "pending"
      )
      existing = existing.where.not(id: id) if persisted?

      if existing.exists?
        errors.add(:email_address, "already has a pending invite for this organization")
      end
    end

    def cannot_invite_existing_org_member
      return if email_address.blank?

      if organization.users.where(email_address: email_address).exists?
        errors.add(:email_address, "already belongs to a member of this organization")
      end
    end
end
