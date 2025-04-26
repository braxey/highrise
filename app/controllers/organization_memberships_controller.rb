class OrganizationMembershipsController < ApplicationController
  before_action :set_organization
  before_action :set_organization_membership, only: %i[ edit update destroy ]

  def index
    @organization_memberships = @organization.organization_memberships.includes(:user, :role)
    @invitations = @organization.organization_invitations.pending.includes(:role)
  end

  def edit
  end

  def update
    if @organization_membership.update(organization_membership_params.slice(:role_id))
      redirect_to organization_organization_memberships_path(@organization), notice: "Role of #{@user_name} updated successfully"
    else
      redirect_to organization_organization_memberships_path(@organization), alert: "Failed to update role of #{@user_name}: #{invitation.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @organization_membership.destroy!

    redirect_to organization_organization_memberships_path(@organization), status: :see_other, notice: "Membership of #{@user_name} revoked successfully"
  end

  private
    def set_organization
      @organization = Organization.find(params.expect(:organization_id))
    end

    def set_organization_membership
      @organization_membership = @organization.organization_memberships.find(params.expect(:id))
      @user_name = "#{@organization_membership.user.first_name} #{@organization_membership.user.last_name}"
    end

    def organization_membership_params
      params.expect(organization_membership: [ :email_address, :role_id ])
    end
end
