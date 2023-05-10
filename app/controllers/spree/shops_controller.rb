module Spree
  class ShopsController < Spree::StoreController
    def index; end

    def show
      @shop = Spree::Vendor.find_by(slug: params[:slug])
    end

    def searh
      @shops = Spree::Vendor.where('name LIKE ?', "%#{params[:q]}%")
    end
  end
end
