module Spree
  class CountryController < StoreController
    def set
      new_country = params[:switch_to_country_id]&.upcase

      if new_country.present?
        session[:country] = new_country

        begin
          spree_current_user.update(default_country: new_country) if spree_current_user.present?
        rescue StandardError => e
          flash[:error] = e.message
        end
      end

      respond_to do |format|
        format.html { redirect_back fallback_location: spree.root_path(country: new_country) }
        format.json { head :ok }
      end
    end
  end
end
