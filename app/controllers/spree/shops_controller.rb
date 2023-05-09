module Spree
  class ShopsController < Spree::StoreController
    def index; end

    def show
      @shop = Spree::Vendor.find_by(slug: params[:slug])
    end
  end
end
