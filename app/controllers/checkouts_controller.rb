class CheckoutsController < ApplicationController
  before_action :require_user
  before_action :require_admin, only: [:review, :index, :approve]

  def review
    @checkouts = Checkout.pending_approval.order(:checkout_time)
    @approved = Checkout.approved.order('checkout_time DESC')
  end

  def approve
    @checkout = Checkout.pending_approval.find(params[:id])
    @checkout.status = 2
    if @checkout.save
      flash[:success] = 'Checkout approved!'
      redirect_to checkout_review_path
    else 
      flash[:error] = 'Checkout failed to approve.'
      redirect_to checkout_review_path
    end
  end

  def show
    @checkout_items = current_checkout.checkout_items
  end

  def checkout_begin
    @checkout = current_checkout
    @checkout_items = current_checkout.checkout_items
    if @checkout_items.size == 0
      redirect_to cart_path
    end
  end

  def checkout_end
    @checkout = current_checkout
    cps = checkout_params
    cps[:status] = 1
    cps[:checkout_time] = Time.zone.now
    if @checkout.update(cps)
      current_user.current_checkout_id = nil
      current_user.save
      redirect_to '/'
    else
      flash[:error] = @checkout.errors.full_messages
      redirect_to checkout_begin_path
    end
  end

  private
  def checkout_params
    params.require(:checkout).permit(:need_by, :return_by, :reason, :notes)
  end
end
