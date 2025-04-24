class UsersMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    mail to: @user.email_address
  end
end
