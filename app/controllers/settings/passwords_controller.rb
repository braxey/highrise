# app/controllers/settings/passwords_controller.rb
module Settings
  class PasswordsController < ApplicationController
    before_action :set_user

    def show
    end

    def update
      unless @user.authenticate(params[:user][:current_password])
        @user.errors.add(:current_password, "is incorrect")
        return render :show, status: :unprocessable_entity
      end

      if @user.update(password_params)
        redirect_to settings_password_path, flash: { success: "Saved" }
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = session_user
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
end
