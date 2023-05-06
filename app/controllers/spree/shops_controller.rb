module Spree
  class ShopsController < Spree::StoreController
    def show
      @shop = Spree::Vendor.find_by(slug: params[:slug])
    end
  end
end
