class CartsController < ApplicationController
  before_action :require_user

  def show
    @checkout_items = current_checkout.checkout_items
  end

  def checkout_begin
    @checkout_items = current_checkout.checkout_items
  end

  def checkout
    @checkout = current_checkout
    if @checkout.update(checkout_params)
      @checkout.update(status: 1, checkout_time: Time.zone.now)
      current_user.current_checkout_id = nil
      redirect_to checkout_confirm_path
    else
      flash[:error] = @checkout.errors.full_messages
      redirect_to checkout_begin_path
    end
  end

  private
  def checkout_params
    params.require(:checkout).permit(:need_by, :return_by)
  end
end
