module Authorization
  extend ActiveSupport::Concern

  class_methods do
    def require_authorization(authorized, **options)
      before_action(**options) do
        unless instance_exec(&authorized)
          redirect_to options[:redirect_location] || root_url
        end
      end
    end

    # Require the session user to have role(s)
    def require_role(role, **options)
      before_action -> { redirect_if_role_not_in([ role ], options[:redirect_location] || root_url) }, **options
    end

    def require_role_in(roles, **options)
      before_action -> { redirect_if_role_not_in(roles, options[:redirect_location] || root_url) }, **options
    end
  end

  private
    def redirect_if_role_not_in(authorized_roles, redirect_location)
      if not authorized_roles.include? session_user.role
        redirect_to redirect_location
      end
    end
end
