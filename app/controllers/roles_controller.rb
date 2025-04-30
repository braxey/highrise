class RolesController < ApplicationController
  require_role(Role.where(scope: "user", name: "Admin").first)
  before_action :set_role, only: %i[ edit update destroy ]

  def index
    @roles = Role.all.group_by(&:scope)
  end

  def new
    @role = Role.new
  end

  def edit
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      redirect_to roles_path, notice: "Role was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @role.update(role_params)
      redirect_to roles_path, notice: "Role was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @role.destroy!
    redirect_to roles_path, status: :see_other, notice: "Role was successfully deleted."
  end

  private
    def set_role
      @role = Role.find(params.expect(:id))
    end

    def role_params
      params.expect(role: [ :name, :scope ])
    end
end
