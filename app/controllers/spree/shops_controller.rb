module Spree
  class ShopsController < Spree::StoreController
    load_and_authorize_resource class: Spree::Vendor, only: [:onboarding, :create]
    layout :get_layout

    before_action :load_shipping_methods_data, only: [:onboarding, :onboarding_update, :edit_product, :create_product, :update_product]

    def index; end

    def show
      @shop = Spree::Vendor.find_by(slug: params[:slug])
      @searcher = build_searcher(params.merge(include_images: true, current_store: current_store, current_vendor: @shop, show_discontinued: true))
      @products = @searcher.retrieve_products
    end

    def search
      @local_country = Spree::Country.find_by(iso: 'US')
      @local_country = Spree::Country.find_by(iso: spree_current_user.default_country) if spree_current_user.present?

      @shops = Spree::Vendor.where(country_id: @local_country.id).ransack(name_cont: params[:q]).result(distinct: true).page(params[:page]).per(12)
    end

    def onboarding
      @shop = Spree::Vendor.find_by(slug: params[:slug]) || spree_current_user.vendors.pending.first || Spree::Vendor.new

      if @shop.persisted? && @shop.products.empty?
        redirect_to spree.shop_onboarding_path(@shop.slug, screen_type: 'products')
      elsif @shop.persisted? && @shop.products.present? && @shop.shipping_methods.empty?
        redirect_to spree.shop_onboarding_path(@shop.slug, screen_type: 'shipping')
      elsif @shop.persisted? && @shop.products.present? && @shop.shipping_methods.present? && @shop.payment_methods.empty?
        redirect_to spree.shop_onboarding_path(@shop.slug, screen_type: 'payment')
      elsif @shop.persisted? && @shop.products.present? && @shop.shipping_methods.present? && @shop.payment_methods.present?
        redirect_to spree.shop_path(@shop.slug)
      else
        @shop = Spree::Vendor.find_by(slug: params[:slug]) || spree_current_user.vendors.pending.first || Spree::Vendor.new
      end
    end

    def onboarding_update
      @shop = Spree::Vendor.find_by(slug: params[:slug])
      @screen_type = params[:screen_type]
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

    def create_product
      @shop = Spree::Vendor.find_by(slug: params[:slug])
      @product = Spree::Product.new(product_params.except(:variant_images, :variant_images_files, :quantity))
      @product.vendor_id = @shop.id
      @product.store_ids = [current_store.id]

      if product_params[:variant_images_files].present?
        product_params[:variant_images_files].each do |image|
          @product.images.build(attachment: image)
        end
      end

      if @product.save
        if product_params[:quantity].present?
          @stock_item = @shop.stock_locations.first.stock_item_or_create(@product.master)
          @stock_item.set_count_on_hand(product_params[:quantity].to_i)
        end

        flash[:success] = 'Product created successfully'
        redirect_to spree.shop_path(@shop.slug)
      else
        flash[:error] = @product.errors.full_messages.join(', ')
        redirect_to spree.shop_onboarding_path(@shop.slug, screen_type: 'products')
      end
    end

    def edit_product
      @shop = Spree::Vendor.find_by(slug: params[:slug])
      @product = Spree::Product.find_by(slug: params[:product_slug])
    end

    def update_product
      @shop = Spree::Vendor.find_by(slug: params[:slug])
      @product = Spree::Product.find_by(slug: params[:product_slug])

      @product.assign_attributes(product_params.except(:variant_images, :variant_images_files, :quantity, :variant_images_files_remove))

      if product_params[:variant_images_files].present?
        product_params[:variant_images_files].each do |image|
          @product.images.create!(attachment: image)
        end
      end

      if product_params[:variant_images_files_remove].present?
        product_params[:variant_images_files_remove].each do |image|
          @product.images.find_by(id: image).destroy
        end
      end

      if @product.save
        if product_params[:quantity].present?
          @stock_item = @shop.stock_locations.first.stock_item_or_create(@product.master)
          @stock_item.set_count_on_hand(product_params[:quantity].to_i)
        end

        flash[:success] = 'Product updated successfully'
        redirect_to spree.shop_path(@shop.slug)
      else
        flash[:error] = @product.errors.full_messages.join(', ')
        redirect_to spree.edit_shop_product_path(@shop.slug, @product.slug)
      end
    end

    private

    def load_shipping_methods_data
      @available_zones = Spree::Zone.order(:name)
      @tax_categories = Spree::TaxCategory.order(:name)
      @calculators = Spree::ShippingMethod.calculators.sort_by(&:name)
    end

    def get_layout
      if %w[onboarding onboarding_update edit_product update_product create_product].include?(action_name)
        'spree/layouts/application'
      else
        'spree/layouts/spree_application'
      end
    end

    def product_params
      params.require(:product).permit(permitted_product_attributes, :quantity, variant_images: [], variant_images_files: [], variant_images_files_remove: [])
    end

    def shop_params
      params.require(:vendor).permit(:name, :slug, :email, :about_us, :notification_email, :logo, :country_id, :state_id, :city, :address1, :address2, :zip, :phone, :fax, :active)
    end
  end
end
