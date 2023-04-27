module Spree
  class ErrorsController < StoreController
    def forbidden
      render status: :forbidden
    end

    def unauthorized
      render status: :unauthorized
    end
  end
end
