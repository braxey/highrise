class RolesController < ApplicationController
  require_phoenix_admin
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
      redirect_to edit_role_path(@role), flash: { success: "Saved" }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @role.destroy!
    redirect_to roles_path, status: :see_other
  end

  def destroy
    unless "#{@role.scope}/#{@role.name}" == params[:delete_role]
      flash[:delete_error] = "Roles did not match"
      flash[:open_modal] = true
      return render :edit, status: :unprocessable_entity
    end

    scope = @role.scope
    name = @role.name

    @role.destroy!
    redirect_to roles_path, status: :see_other, notice: "Role #{scope}/#{name} was successfully deleted."
  end

  private
    def set_role
      @role = Role.find(params.expect(:id))
    end

    def role_params
      params.expect(role: [ :name, :scope ])
    end
end
