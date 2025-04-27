class OrganizationInvitationsMailer < ApplicationMailer
  def notify_invited
    @organization_invitation = params[:organization_invitation]
    @organization = @organization_invitation.organization

    mail subject: "You've been invited", to: @organization_invitation.email_address
  end
end
