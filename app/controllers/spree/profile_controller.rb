class Spree::ProfileController < Spree::StoreController
  before_action :set_current_user
  include Spree::Core::ControllerHelpers

  def show; end

  def edit; end

  def preferences; end

  def addresses
    @billing_address = @user.billing_address
    @shipping_address = @user.shipping_address
  end


  private

  def set_current_user
    @user = spree_current_user
  end
end
