module Spree
  module Admin
    class DashboardController < BaseController
      def show
        if current_spree_vendor.present?
          @products_added = current_spree_vendor.products.any?
          @shipping_methods_added = Spree::ShippingMethod.any?
          @taxes_added = Spree::TaxRate.any?
          @onboarding_complete = @products_added && @shipping_methods_added && @taxes_added
          @shippable_countries = Spree::ShippingMethod.all.collect(&:zones).flatten.uniq.compact.collect(&:countries).flatten.uniq.sort_by(&:name)

          @active_tab = if !@products_added
                          'products'
                        elsif !@shipping_methods_added
                          'shipping'
                        elsif !@payment_methods_added
                          'payment'
                        else
                          'taxes'
                        end

          @total_revenue = current_spree_vendor.sales_total
          @this_month = current_spree_vendor.this_month_sales
          @last_month = current_spree_vendor.last_month_sales
          @last_12_mos = current_spree_vendor.last_12_mos_sales
          @total_pending_orders = current_spree_vendor.pending_orders_count
          @total_orders = current_spree_vendor.sales_count
          @total_commissions = current_spree_vendor.commission_total
          @total_products = current_spree_vendor.products.count
          @total_customers = current_spree_vendor.customers_count
        else
          @products_added = current_store.products.any?
          @shipping_methods_added = Spree::ShippingMethod.any?
          @payment_methods_added = current_store.payment_methods.any?
          @taxes_added = Spree::TaxRate.any?

          @onboarding_complete = @products_added && @shipping_methods_added && @payment_methods_added && @taxes_added

          @shippable_countries = Spree::ShippingMethod.all.collect(&:zones).flatten.uniq.compact.collect(&:countries).flatten.uniq.sort_by(&:name)

          @active_tab = if !@products_added
                          'products'
                        elsif !@shipping_methods_added
                          'shipping'
                        elsif !@payment_methods_added
                          'payment'
                        else
                          'taxes'
                        end
        end
      end
    end
  end
end
