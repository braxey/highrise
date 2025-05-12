class ApplicationController < ActionController::Base
  include Authentication
  include Authorization
  allow_browser versions: :modern

  protected
    def prefetching?
      prefetch_headers = %w[
        Purpose
        Sec-Purpose
        X-Sec-Purpose
        HTTP_PURPOSE
        HTTP_SEC_PURPOSE
      ]

      prefetch_headers.any? { |key| request.headers[key] == "prefetch" }
    end
end
