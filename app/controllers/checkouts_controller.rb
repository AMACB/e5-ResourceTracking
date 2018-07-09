class CheckoutsController < ApplicationController
  before_action :require_user
  before_action :require_admin, only: [:review, :approve]

  def review
    @checkouts = Checkout.pending_approval.order(:checkout_time)
    @approved = Checkout.approved.order('checkout_time DESC')
  end

  def approve
    @checkout = Checkout.pending_approval.find(params[:id])
    @checkout.status = 2
    if @checkout.save
      @checkout.user.notifications.create(notif_type: "checkout_approved", importance: 4, head: "Your Request was Approved", body: "Your recent checkout for \"#{@checkout.reason}\" was approved!")
      flash[:success] = 'Checkout approved!'
      redirect_to checkout_review_path
    else 
      flash[:error] = 'Checkout failed to approve. Error(s): ' + @checkout.errors.full_messages.to_sentence
      redirect_to checkout_review_path
    end
  end

  def reject
    @checkout = Checkout.pending_approval.find(params[:id])
    @checkout.status = 0
    @checkout.rejected = true
    @checkout.rejected_msg = params[:rejected_msg]
    if @checkout.save
      @checkout.user.notifications.create(notif_type: "checkout_rejected", importance: 4, head: "Your Request was Rejected", body: "Your recent checkout for \"#{@checkout.reason}\" was rejected. Reason given: \"#{@checkout.rejected_msg}\"")
      flash[:success] = 'Checkout rejected!'
      redirect_to checkout_review_path
    else 
      flash[:error] = 'Checkout failed to reject. Error(s): ' + @checkout.errors.full_messages.to_sentence
      redirect_to checkout_review_path
    end
  end

  def show
    @checkout = current_checkout
    @checkout_items = current_checkout.checkout_items
    @checkout_errors = current_checkout.errors_on_checkout
  end

  def update
    @checkout = current_checkout
    if @checkout.update(cart_change_params)
      flash[:success] = 'Update was successful!'
      current_user.current_checkout_id = @checkout.id
      current_user.save
      redirect_to cart_path
    else
      flash[:error] = 'Update failed. Error(s): ' + @checkout.errors.full_messages.to_sentence
      redirect_to cart_path
    end
  end

  def index
    @checkouts = current_user.checkouts.where('status != 0').order('checkout_time DESC')
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

  def cart_change_params
    params.permit(:need_by, :return_by)
  end
end
