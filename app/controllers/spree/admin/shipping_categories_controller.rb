module Spree
  module Admin
    class ShippingCategoriesController < ResourceController

      def permitted_resource_params
        params.require(:shipping_category).permit(:name, :description)
      end
    end
  end
end
