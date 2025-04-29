class PagesController < ApplicationController
  disallow_authenticated_access only: :home, redirect_location: :dashboard

  def home
  end

  def dashboard
  end
end
