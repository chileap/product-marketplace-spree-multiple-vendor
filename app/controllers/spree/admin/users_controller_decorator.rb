module Spree::Admin::UsersControllerDecorator
  def find_resource
    if parent_data.present?
      parent.send(controller_name).friendly.find(params[:id])
    else
      base_scope = model_class.try(:for_store, current_store) || model_class
      base_scope.friendly.find(params[:id])
    end
  end
end

Spree::Admin::UsersController.prepend Spree::Admin::UsersControllerDecorator
