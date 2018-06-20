class CheckoutItemsController < ApplicationController
  before_action :require_user

  def create
    @checkout = current_checkout
    @checkout_item = @checkout.checkout_items.new(checkout_item_params)
    @checkout.save
    @current_user.update_attribute :current_checkout_id, @checkout.id
  end

  # TODO ensure that user can only modify their own
  def update
    @checkout = current_checkout
    @checkout_item = @checkout.checkout_items.find(params[:id])
    @checkout_item.update_attributes(checkout_item_params)
    @checkout_items = @checkout.checkout_items
  end

  def destroy
    @checkout = current_checkout
    @checkout_item = @checkout.checkout_items.find(params[:id])
    @checkout_item.destroy
    @checkout_items = @checkout.checkout_items
  end

  private
  def checkout_item_params
    params.require(:checkout_item).permit(:quantity, :item_id, :checkout_id)
  end
end
