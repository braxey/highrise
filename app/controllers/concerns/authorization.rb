module Authorization
  extend ActiveSupport::Concern

  class_methods do
    def require_role(role, **options)
      before_action -> { redirect_if_unauthorized(role, options[:redirect_location] || root_url) }, **options
    end
  end

  private
    def redirect_if_unauthorized(role, redirect_location)
      user_role = Current.session.user.role

      if user_role&.id != role.id
        redirect_to redirect_location
      end
    end
end
