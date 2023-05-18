module Spree
  class ShopsController < Spree::StoreController
    def index; end

    def show
      @shop = Spree::Vendor.find_by(slug: params[:slug])
    end

    def search
      @local_country = Spree::Country.find_by(iso: 'US')
      @local_country = Spree::Country.find_by(iso: spree_current_user.default_country) if spree_current_user.present?

      @shops = Spree::Vendor.where(country_id: @local_country.id).ransack(name_cont: params[:q]).result(distinct: true).page(params[:page]).per(12)
    end
  end
end
