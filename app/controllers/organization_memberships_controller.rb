class OrganizationMembershipsController < ApplicationController
  before_action :set_organization
  before_action :set_organization_membership, only: %i[ edit update destroy ]

  def index
    @per_page = 8

    @current_page = params[:page].to_i || 1
    @current_page = 1 if @current_page < 1
    offset = (@current_page - 1) * @per_page

    @search_query = params[:search].to_s || ""

    @query = @organization.organization_memberships.all

    if @search_query.present?
      @query = @query
        .joins(:user)
        .where("users.email_address LIKE ?", "%#{@search_query}%")
    end

    @total_memberships = @query.count
    @last_page = (@total_memberships/@per_page.to_f).ceil
    @start_number = [ offset + 1, @total_memberships ].min
    @end_number = [ offset + @per_page, @total_memberships ].min

    @organization_memberships = @query.includes(:user, :role).limit(@per_page).offset(offset)
  end

  def edit
  end

  def update
    if @organization_membership.update(role_id: Role.find(organization_membership_params[:role]).id)
      redirect_to edit_organization_organization_membership_path(@organization), flash: { success: "Saved" }
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
