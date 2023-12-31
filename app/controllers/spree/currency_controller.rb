module Spree
  class CurrencyController < StoreController
    def set
      new_currency = params[:switch_to_currency]&.upcase

      if new_currency.present? && supported_currency?(new_currency)
        session[:currency] = new_currency

        begin
          current_order.update(currency: new_currency)
          spree_current_user.update(default_currency: new_currency) if spree_current_user.present?
        rescue StandardError => e
          flash[:error] = e.message
        end
      end

      respond_to do |format|
        format.html { redirect_back fallback_location: spree.root_path(currency: new_currency) }
        format.json { head :ok }
      end
    end
  end
end
