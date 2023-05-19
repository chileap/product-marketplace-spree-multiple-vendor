module Spree
  class ShopsController < Spree::StoreController
    load_and_authorize_resource class: Spree::Vendor, only: %i[onboarding]

    layout 'spree/layouts/application'

    def index; end

    def show
      @shop = Spree::Vendor.find_by(slug: params[:slug])
    end

    def search
      @local_country = Spree::Country.find_by(iso: 'US')
      @local_country = Spree::Country.find_by(iso: spree_current_user.default_country) if spree_current_user.present?

      @shops = Spree::Vendor.where(country_id: @local_country.id).ransack(name_cont: params[:q]).result(distinct: true).page(params[:page]).per(12)
    end

    def onboarding
      @shop = Spree::Vendor.find_by(slug: params[:slug]) || spree_current_user.vendors.pending.first || Spree::Vendor.new
    end

    def create
      @shop = Spree::Vendor.new(shop_params)
      @shop.status = 'pending'
      @shop.users << spree_current_user
      if @shop.save
        flash[:success] = 'Shop created successfully'
        redirect_to spree.shop_onboarding_path(@shop.slug, screen_type: 'products')
      else
        flash[:error] = @shop.errors.full_messages.join(', ')
        redirect_to spree.onboarding_path
      end
    end

    def update
      @shop = Spree::Vendor.find_by(slug: params[:slug])
      if @shop.update(shop_params)
        flash[:success] = 'Shop updated successfully'
        redirect_to spree.shop_onboarding_path(@shop.slug, screen_type: 'products')
      else
        flash[:error] = @shop.errors.full_messages.join(', ')
        redirect_to spree.onboarding_path
      end
    end

    private

    def shop_params
      params.require(:vendor).permit(:name, :slug, :email, :about_us, :notification_email, :logo, :country_id, :state_id, :city, :address1, :address2, :zip, :phone, :fax, :active)
    end
  end
end
