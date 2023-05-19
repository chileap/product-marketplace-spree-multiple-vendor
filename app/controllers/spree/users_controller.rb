class Spree::UsersController < Spree::StoreController
  before_action :set_current_order, except: :show
  prepend_before_action :authorize_actions, only: :new

  include Spree::Core::ControllerHelpers

  def profile
    @user = Spree.user_class.friendly.find(params[:slug])
    @orders = @user.orders.for_store(current_store).complete.order('completed_at desc')
  end

  def show
    @user = Spree.user_class.friendly.find(params[:slug])
    @orders = @user.orders.for_store(current_store).complete.order('completed_at desc')
  end

  def edit
    load_object
  end

  def create
    @user = Spree.user_class.new(user_params)
    if @user.save

      if current_order
        session[:guest_token] = nil
      end

      redirect_back_or_default(root_url)
    else
      render :new
    end
  end

  def update
    load_object

    @user.create_profile_picture(attachment: user_params[:profile_picture]) if user_params[:profile_picture].present?
    if @user.update(user_params.except(:profile_picture))
      if params[:user][:password].present?
        # this logic needed b/c devise wants to log us out after password changes
        Spree.user_class.reset_password_by_token(params[:user])
        if Spree::Auth::Config[:signout_after_password_change]
          sign_in(@user, event: :authentication)
        else
          bypass_sign_in(@user)
        end
      end
      redirect_to spree.user_profile_path(@user), notice: Spree.t(:account_updated)
    else
      flash[:error] = @user.errors.full_messages.join(', ')
      redirect_to spree.user_account_path, status: :unprocessable_entity
    end
  end

  def update_profile_picture
    load_object
    @user.create_profile_picture(attachment: user_params[:profile_picture]) if user_params[:profile_picture].present?
    redirect_to spree.user_profile_path(@user), notice: Spree.t(:account_updated)
  end

  private

  def user_params
    params.require(:user).permit(
      Spree::PermittedAttributes.user_attributes,
      :profile_picture,
      :default_city,
      :default_country,
      :default_currency,
      :default_language
    )
  end

  def load_object
    @user ||= spree_current_user
    authorize! params[:action].to_sym, @user
  end

  def authorize_actions
    authorize! params[:action].to_sym, Spree.user_class.new
  end

  def accurate_title
    Spree.t(:my_account)
  end
end
