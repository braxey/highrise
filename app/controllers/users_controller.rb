class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  disallow_authenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_user_url, alert: "Try again later." }
  layout "auth", only: %i[ new create ]
  before_action :set_user, only: %i[ edit update ]

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(create_user_params)
    if @user.save
      start_new_session_for @user
      redirect_to dashboard_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(update_user_params)
      redirect_to settings_profile_path, flash: { success: "Saved" }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = session_user
    end

    def create_user_params
      params.expect(user: [ :email_address, :password, :password_confirmation, :first_name, :last_name ])
    end

    def update_user_params
      params.expect(user: [ :email_address, :first_name, :last_name ])
    end
end
