class RequestItemsController < ApplicationController
  before_action :require_user

  def create
    @request = current_request
    @request_item = @request.request_items.new(request_item_params)
    @request.save
    @current_user.current_request_id = @request.id
    @current_user.save
    @request_items = @request.request_items

    @requested_items = Array.new
    @request_items.each do |i|
      @requested_items.push(i.item_id)
    end

    respond_to do |format|
      format.html { redirect_to @request_items, notice: "New item created successfully"}
      format.js
      format.json
    end
  end

  # TODO ensure that user can only modify their own
  def update
    @request = current_request
    @request_item = @request.request_items.find(params[:id])
    @request_items = @request.request_items

    respond_to do |format|
      if @request_item.update(request_item_params)
        format.html { redirect_to @request_items, notice: "Quantity updated successfully"}
        format.js
        format.json { render json: @request_items, status: :updated, location: @request_items }
      else 
        format.html { render action: "update" }
        format.js
        format.json { render json: @request_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @request = current_request
    @request_item = @request.request_items.find(params[:id])
    @request_item.destroy
    @request_items = @request.request_items
  end

  private
  def request_item_params
    params.require(:request_item).permit(:quantity, :item_id, :request_id)
  end

  def ensure_quantity_valid(ci)
    unless ci[:quantity] <= ci[:item][:available]
      throw Exception
    end
  end
end
