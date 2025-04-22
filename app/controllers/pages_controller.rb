class PagesController < ApplicationController
  disallow_authenticated_access only: :home, fallback_location: :another_page

  def home
  end

  def dashboard
  end
end
