class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[ show edit update destroy ]
  require_phoenix_admin only: %i[ index new ]
  require_authorization -> { authorized_to_manage_organization(@organization) }, only: %i[ show edit update destroy ]

  def index
    @per_page = 8

    @current_page = params[:page].to_i || 1
    @current_page = 1 if @current_page < 1
    offset = (@current_page - 1) * @per_page

    @search_query = params[:search].to_s || ""
    @status_query = params[:status].to_s || "all"
    @status_query = "all" unless [ "all", "active", "inactive" ].include?(@status_query)

    @query = Organization.all

    if @search_query.present?
      @query = @query.where("name LIKE ?", "%#{@search_query}%")
    end

    if @status_query != "all"
      @query = @query.where(is_active: @status_query == "active")
    end

    @total_organizations = @query.count
    @last_page = (@total_organizations/@per_page.to_f).ceil
    @start_number = [ offset + 1, @total_organizations ].min
    @end_number = [ offset + @per_page, @total_organizations ].min

    @organizations = @query.includes(:users).limit(@per_page).offset(offset)
  end

  def show
  end

  def new
    @organization = Organization.new
  end

  def edit
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      redirect_to organization_path(@organization)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @organization.update(organization_params)
      redirect_to edit_organization_path(@organization), flash: { success: "Saved" }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @organization.name == params[:delete_name]
      flash[:delete_error] = "Names did not match"
      flash[:open_modal] = true
      return render :edit, status: :unprocessable_entity
    end

    name = @organization.name
    @organization.destroy!
    redirect_to organizations_path, status: :see_other, notice: "Organization #{name} was successfully deleted."
  end

  private
    def set_organization
      @organization = Organization.find(params.expect(:id))
    end

    def organization_params
      params.expect(organization: [ :name, :is_active ])
    end

    def authorized_to_manage_organization(organization)
      organization_membership = organization.organization_memberships.where(user: session_user).first
      organization_admin_role = Role.where(scope: Constants::Roles::Scopes::ORGANIZATION, name: Constants::Roles::Names::ADMIN).first
      is_organization_admin = organization_membership&.role == organization_admin_role

      is_phoenix_admin? || is_organization_admin
    end
end
