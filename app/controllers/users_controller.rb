class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  disallow_authenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_user_url, alert: "Try again later." }

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to dashboard_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.expect(user: [ :email_address, :password, :password_confirmation ])
    end
end
