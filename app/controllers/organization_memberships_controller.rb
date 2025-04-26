class OrganizationMembershipsController < ApplicationController
  before_action :set_organization
  before_action :set_organization_membership, only: %i[ show edit update destroy ]

  def index
    @organization_memberships = @organization.organization_memberships.includes(:user, :role)
  end

  def show
  end

  def new
    @organization_membership = @organization.organization_memberships.build
  end

  def edit
  end

  def create
    email = organization_membership_params[:email_address]&.strip.downcase
    user = User.find_by(email_address: email) || create_new_user(email)

    if user && @organization.users.include?(user)
      redirect_to new_organization_organization_membership_path(@organization), alert: "User is already a member of this organization"; return
    end

    @organization_membership = @organization.organization_memberships.build(user: user, role_id: organization_membership_params[:role_id])

    if @organization_membership.save
      redirect_to organization_organization_memberships_path(@organization), notice: "Organization membership was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if @organization_membership.update(organization_membership_params.slice(:role_id))
        format.html { redirect_to organization_organization_memberships_path(@organization), notice: "Organization membership was successfully updated." }
        format.json { render :show, status: :ok, location: @organization_membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @organization_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @organization_membership.destroy!

    respond_to do |format|
      format.html { redirect_to organization_organization_memberships_path(@organization), status: :see_other, notice: "Organization membership was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_organization
      @organization = Organization.find(params.expect(:organization_id))
    end

    def set_organization_membership
      @organization_membership = @organization.organization_memberships.find(params.expect(:id))
    end

    def organization_membership_params
      params.expect(organization_membership: [ :email_address, :role_id ])
    end

    def create_new_user(email)
      User.create!(
        email_address: email,
        password: SecureRandom.hex(16),
        first_name: "New",
        last_name: "User",
        is_active: true
      )
    rescue ActiveRecord::RecordInvalid
      nil
    end
end
