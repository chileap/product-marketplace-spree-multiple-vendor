module Spree
  class VendorsController < Spree::StoreController
    before_action :load_vendor, only: :show

    def show
      @products = @vendor.products.page(params[:page]).per(12)
    end

    def load_vendor
      @vendor = Spree::Vendor.friendly.find(params[:id])
    end
  end
end
