class OrganizationInvitationsMailerPreview < ActionMailer::Preview
  def notify_invited
    session_user = User.take
    organization = Organization.take
    role = Role.where(scope: Constants::Roles::Scopes::ORGANIZATION, name: Constants::Roles::Names::ADMIN).first

    invitation = organization.organization_invitations.build(
      role: role,
      invited_by: session_user,
      email_address: "invitee@phoenix.com",
      status: "pending",
      accepted_at: nil,
      denied_at: nil,
    )

    OrganizationInvitationsMailer.with(organization_invitation: invitation).notify_invited
  end
end
