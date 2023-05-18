class Spree::ProfileController < Spree::StoreController
  REDIRECT_TO_ROOT = /\/(pages)\//.freeze

  before_action :set_current_user
  include Spree::Core::ControllerHelpers

  def show; end

  def edit; end

  def preferences; end

  def addresses
    @billing_address = @user.billing_address
    @shipping_address = @user.shipping_address
  end

  def update_preferences
    if @user.update(user_params.except(:profile_picture))
      session[:currency] = @user.default_currency

      if @user.saved_change_to_default_language?
        if should_build_new_url?
          redirect_to Spree::BuildLocalizedRedirectUrl.call(
            url: request.env['HTTP_REFERER'],
            locale: @user.default_language,
            default_locale: @user.default_language
          ).value
        else
          redirect_to spree.user_preferences_path(locale: @user.default_language)
        end
      elsif @user.saved_change_to_default_currency?
        flash[:success] = Spree.t(:account_updated)
        redirect_to spree.user_preferences_path(currency: @user.default_currency)
      else
        flash[:success] = Spree.t(:account_updated)
        redirect_to spree.user_preferences_path
      end
    else
      flash[:error] = @user.errors.full_messages.join(', ')
      redirect_to spree.user_preferences_path, status: :unprocessable_entity
    end
  end

  private

  def should_build_new_url?
    return false if request.env['HTTP_REFERER'].blank?

    if request.env['HTTP_REFERER'].match(REDIRECT_TO_ROOT)
      false
    else
      request.env['HTTP_REFERER'] != request.env['REQUEST_URI']
    end
  end

  def user_params
    params.require(:user).permit(
      :default_city,
      :default_country,
      :default_currency,
      :default_language
    )
  end

  def set_current_user
    @user = spree_current_user
  end
end
