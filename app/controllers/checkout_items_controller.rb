class CheckoutItemsController < ApplicationController
  before_action :require_user

  def create
    @checkout = current_checkout
    @checkout_item = @checkout.checkout_items.new(checkout_item_params)
    @checkout.save
    @current_user.update_attribute :current_checkout_id, @checkout.id
    @checkout_items = @checkout.checkout_items

    @checked_out_items = Array.new
    @checkout_items.each do |i|
      @checked_out_items.push(i.item_id)
    end

    respond_to do |format|
      format.html { redirect_to @checkout_items, notice: "New item created successfully"}
      format.js
      format.json
    end
  end

  # TODO ensure that user can only modify their own
  def update
    @checkout = current_checkout
    @checkout_item = @checkout.checkout_items.find(params[:id])
    @checkout_items = @checkout.checkout_items

    respond_to do |format|
      if @checkout_item.update(checkout_item_params)
        format.html { redirect_to @checkout_items, notice: "Quantity updated successfully"}
        format.js
        format.json { render json: @checkout_items, status: :updated, location: @checkout_items }
      else 
        format.html { render action: "update" }
        format.js
        format.json { render json: @checkout_item.errors, status: :unprocessable_entity }
      end
    end 

    
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

  def ensure_quantity_valid(ci)
    unless ci[:quantity] <= ci[:item][:available]
      throw Exception
    end
  end
end
