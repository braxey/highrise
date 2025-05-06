module Settings
  class ProfilesController < ApplicationController
    before_action :set_user

    def show
    end

    def update
      if @user.update(profile_params)
        redirect_to settings_profile_path, flash: { success: "Saved" }
      else
        render :show, status: :unprocessable_entity
      end
    end

    def destroy
      unless @user.authenticate(params[:password])
        flash[:error] = "Incorrect password."
        flash[:open_modal] = true
        return render :show, status: :unprocessable_entity
      end

      @user.destroy
      reset_session
      redirect_to root_path
    end

    private
      def set_user
        @user = session_user
      end

      def profile_params
        params.require(:user).permit(:first_name, :last_name, :email_address)
      end
  end
end
