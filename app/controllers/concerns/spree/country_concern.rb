module Spree
  module CountryConcern
    extend ActiveSupport::Concern

    included do

      if defined?(helper_method)
        helper_method :current_country
        helper_method :available_countries
        helper_method :country_param
      end
    end

    def current_country
      @current_country ||= if params[:country].present?
                            params[:country]
                          elsif spree_current_user&.default_country.present?
                            spree_current_user.default_country
                          else
                            current_store&.default_country
                          end
    end


    def available_countries
      Spree::Store.available_countries
    end

    def country_param
      return if current_country == try_spree_current_user&.default_country
      return if current_country == current_store.default_country

      current_country
    end
  end
end