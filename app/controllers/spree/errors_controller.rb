module Spree
  class ErrorsController < StoreController
    def forbidden
      render status: :forbidden
    end

    def unauthorized
      render status: :unauthorized
    end

    def not_found
      render status: :not_found
    end

    def internal_server
      render status: :internal_server_error
    end
  end
end
