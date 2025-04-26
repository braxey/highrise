class OrganizationInvitationsController < ApplicationController
  before_action :set_organization
  before_action :set_organization_invitation, only: %i[ edit update destroy ]

  def new
    @organization_invitation = @organization.organization_invitations.build
  end

  def edit
  end

  def create
    email = organization_invitation_params[:email_address]&.strip.downcase

    # Find an existing invitation to this email from the organization, or create one.
    invitation = @organization.organization_invitations.find_by(email_address: email) || @organization.organization_invitations.build(
      email_address: email,
      role_id: organization_invitation_params[:role_id],
      invited_by: Current.session.user,
      status: "pending",
      accepted_at: nil,
      denied_at: nil,
    )

    if invitation.save
      redirect_to organization_organization_memberships_path(@organization), notice: "Invitation sent to #{email}"
    else
      redirect_to organization_organization_memberships_path(@organization), alert: "Failed to send invitation to #{email}: #{invitation.errors.full_messages.join(', ')}"
    end
  end

  def update
    if @organization_invitation.update(organization_invitation_params.slice(:role_id))
      redirect_to organization_organization_memberships_path(@organization), notice: "Invitation to #{@organization_invitation.email_address} updated successfully"
    else
      redirect_to organization_organization_memberships_path(@organization), alert: "Failed to update invitation to #{@organization_invitation.email_address}: #{invitation.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    email = @organization_invitation.email_address
    @organization_invitation.destroy!

    redirect_to organization_organization_memberships_path(@organization), status: :see_other, notice: "Invitation to #{email} revoked successfully"
  end

  private
    def set_organization
      @organization = Organization.find(params.expect(:organization_id))
    end

    def set_organization_invitation
      @organization_invitation = @organization.organization_invitations.find(params.expect(:id))
    end

    def organization_invitation_params
      params.expect(organization_invitation: [ :email_address, :role_id ])
    end
end
