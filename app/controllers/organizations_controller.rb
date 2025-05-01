class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[ show edit update destroy ]
  require_phoenix_admin only: %i[ index new ]
  require_authorization -> { authorized_to_manage_organization(@organization) }, only: %i[ show edit update destroy ]

  def index
    @current_page = params[:page].to_i || 1
    @current_page = 1 if @current_page < 1
    @per_page = 10
    offset = (@current_page - 1) * @per_page
    @organizations = Organization.limit(@per_page).offset(offset)
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
      redirect_to @organization, notice: "Organization was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: "Organization was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @organization.destroy!
    redirect_to organizations_path, status: :see_other, notice: "Organization was successfully destroyed."
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
