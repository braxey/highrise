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
    if @organization_membership.update(role_id: Role.find(organization_membership_params[:role]).id)
      redirect_to organization_organization_memberships_path(@organization)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @organization_membership.destroy!

    redirect_to organization_organization_memberships_path(@organization)
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
      params.expect(organization_membership: [ :email_address, :role ])
    end
end
