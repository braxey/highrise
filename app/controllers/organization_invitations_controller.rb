class OrganizationInvitationsController < ApplicationController
  before_action :set_organization
  before_action :set_organization_invitation, only: %i[ show edit update destroy handle_invitation_response ]
  before_action :only_allow_invited, only: %i[ show handle_invitation_response ]
  before_action :only_for_pending_invites, only: %i[ show handle_invitation_response ]

  def new
    @organization_invitation = @organization.organization_invitations.build
  end

  def show
  end

  def edit
  end

  def create
    email = organization_invitation_params[:email_address]&.strip.downcase
    invitation = @organization.organization_invitations.find_by(email_address: email) || @organization.organization_invitations.build

    invitation.assign_attributes(
      email_address: email,
      role_id: organization_invitation_params[:role_id],
      invited_by: session_user,
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

  def handle_invitation_response
    if params[:invite_accepted] == "true"
      @organization.organization_memberships.create!(
        user: session_user,
        role: @organization_invitation.role
      )
      @organization_invitation.update!(status: "accepted", accepted_at: Time.current)
      redirect_to organization_path(@organization), notice: "Invitation accepted. You are now a member of #{@organization.name}."
    else
      @organization_invitation.update!(status: "denied", denied_at: Time.current)
      redirect_to dashboard_path, notice: "Invitation denied."
    end
  end

  private
    def set_organization
      @organization = Organization.find(params.expect(:organization_id))
    end

    def set_organization_invitation
      @organization_invitation = @organization.organization_invitations.find_by!(token: params[:token])
    end

    def only_allow_invited
      unless session_user&.email_address == @organization_invitation.email_address
        redirect_to root_path, alert: "You are not authorized to view this invitation"
      end
    end

    def only_for_pending_invites
      puts @organization_invitation.status
      unless @organization_invitation.status == "pending"
        redirect_to root_path, alert: "This invitation is no longer valid"
      end
    end

    def organization_invitation_params
      params.expect(organization_invitation: [ :email_address, :role_id ])
    end
end
