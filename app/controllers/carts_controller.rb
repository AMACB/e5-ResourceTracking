class CartsController < ApplicationController
  before_action :require_user

  def show
    @checkout_items = current_checkout.checkout_items
  end

  def checkout_begin
    @checkout = current_checkout
    @checkout_items = current_checkout.checkout_items
  end

  def checkout_end
    @checkout = current_checkout
    # puts "params: " + checkout_params.to_s
    cps = checkout_params
    cps[:status] = 1
    cps[:checkout_time] = Time.zone.now
    if @checkout.update(cps)
      # puts "updated!"
      current_user.update_attribute :current_checkout_id, nil
      redirect_to '/'
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
