class RequestsController < ApplicationController
  before_action :require_user
  before_action :require_confirmed_user, only: [:checkout_begin, :checkout_end]
  before_action :require_admin, only: [:review, :approve, :reject]

  def review
    @pending = Request.pending_approval.order(:checkout_time)
    @approved = Request.approved.order('checkout_time DESC')
    @rejected = Request.rejected.order('checkout_time DESC')
  end

  def approve
    @request = Request.pending_approval.find(params[:id])
    @request.status = 2
    @request.reviewed_at = Time.zone.now
    @request.reviewed_by = current_user
    if @request.save
      @request.user.notifications.create(notif_type: "request_approved", importance: 4, head: "Your Request was Approved", body: "Your recent request for \"#{@request.reason}\" was approved! You can pick up your items on #{@request.requested_pick_up_date.strftime('%b %-d, %Y')}.")
      errs = Request.check_for_invalid
      if errs.size > 0
        flash[:notice] = "There were #{errs.size} other request(s) that were automatically rejected due to an item in the approved request being present in a pending request."
      end
      flash[:success] = 'Request approved!'
      redirect_to request_review_path
    else 
      flash[:error] = 'Request failed to approve. Error(s): ' + @request.errors.full_messages.to_sentence
      redirect_to request_review_path
    end
  end

  def reject
    @request = Request.pending_approval.find(params[:id])
    @request.status = 0
    @request.rejected = true
    @request.rejected_msg = params[:rejected_msg]
    @request.reviewed_at = Time.zone.now
    @request.reviewed_by = current_user
    if @request.save
      @request.user.notifications.create(notif_type: "request_rejected", importance: 4, head: "Your Request was Rejected", body: "Your recent request for \"#{@request.reason}\" was rejected. Reason given: \"#{@request.rejected_msg}\"")
      flash[:success] = 'Request rejected!'
      redirect_to request_review_path
    else 
      flash[:error] = 'Request failed to reject. Error(s): ' + @request.errors.full_messages.to_sentence
      redirect_to request_review_path
    end
  end

  def show
    @request = current_request
    @request_items = current_request.request_items
    @request_errors = current_request.errors_on_request
  end

  def update
    @request = current_request
    respond_to do |format|
      if @request.update(cart_change_params)
        current_user.current_request_id = @request.id
        current_user.save

        format.html { redirect_to @request, notice: "Dates updated successfully"}
        format.js
        format.json { render json: @request, status: :updated, location: @request }
      else
        flash[:error] = 'Update failed. Error(s): ' + @request.errors.full_messages.to_sentence
        redirect_to cart_path
      end
    end
  end

  def index
    @requests = current_user.requests.where('status != 0').order('checkout_time DESC')
  end

  def checkout_begin
    @request = current_request
    @request_items = current_request.request_items
    if @request_items.size == 0
      redirect_to cart_path
    end
  end

  def checkout_end
    @request = current_request
    cps = request_params
    cps[:status] = 1
    cps[:checkout_time] = Time.zone.now
    if @request.update(cps)
      flash[:success] = 'Your request was successfully submitted!'
      current_user.current_request_id = nil
      current_user.save
      redirect_to requests_path
    else
      flash[:error] = @request.errors.full_messages
      redirect_to checkout_begin_path
    end
  end

  def check_out_all
    if params[:request_id].present?
      redirect_to check_out_path(params[:request_id])
    end
  end

  def check_in_all
    if params[:request_id].present?
      redirect_to check_in_path(params[:request_id])
    end
  end

  def check_out
    @request = Request.awaiting_pickup.find_by_id(params[:id])
    if @request.nil?
      flash[:error] = 'Could not find a request with a pending check out with the given ID'
      redirect_to check_out_all_path
    end
  end

  def check_in
    @request = Request.awaiting_return.find_by_id(params[:id])
    if @request.nil?
      flash[:error] = 'Could not find a request with a pending check in with the given ID'
      redirect_to check_in_all_path
    end
  end

  def check_out_final
    @request = Request.awaiting_pickup.find_by_id(params[:id])
    if @request.nil?
      flash[:error] = 'Could not find a request with a pending check out with the given ID'
      redirect_to check_out_all_path
    else
      @request.status = 3
      @request.checked_out_by = current_user
      @request.picked_up_at = Time.zone.now
      if @request.save
        @request.user.notifications.create(notif_type: "request_checked_out", importance: 4, head: "Your Items were Checked Out", body: "Your checked out items for reason \"#{@request.reason}\" have successfully been registered in the system. Remember to return your items by #{@request.requested_return_date.strftime("%b %-d, %Y")}.")
        flash[:success] = 'Success!'
        redirect_to check_out_all_path
      else
        flash[:error] = 'An error occurred: ' + @request.errors.full_messages.to_sentence
        redirect_to check_out_all_path
      end
    end
  end

  def check_in_final
    @request = Request.awaiting_return.find_by_id(params[:id])
    if @request.nil?
      flash[:error] = 'Could not find a request with a pending check in with the given ID'
      redirect_to check_in_all_path
    end
    @request.status = 4
    @request.checked_in_by = current_user
    @request.returned_at = Time.zone.now
    if @request.save
      flash[:success] = 'Success!'
      redirect_to check_in_all_path
    else
      flash[:error] = 'An error occurred: ' + @request.errors.full_messages.to_sentence
      redirect_to check_in_all_path
    end
  end

  private
  def request_params
    params.require(:request).permit(:requested_pick_up_date, :requested_return_date, :reason, :notes)
  end

  def cart_change_params
    params.permit(:requested_pick_up_date, :requested_return_date)
  end
end
