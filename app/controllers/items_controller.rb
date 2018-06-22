class ItemsController < ApplicationController
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy, :manage]
  after_action :update_available, only: [:edit]

  def index
    @items = Item.all
    if !current_checkout.nil?
      @checkout_item = current_checkout.checkout_items.new
    end

    @checked_out_items = Array.new
    current_checkout.checkout_items.each do |i|
      @checked_out_items.push(i.item_id)
    end
  end

  def manage
    @items = Item.all
    @new_item = Item.new
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to items_manage_path
    else
      render 'new'
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    respond_to do |format|
      if @item.update(item_edit_params)
        format.html { redirect_to @item, notice: "Item edited successfully"}
        format.js
        format.json { render json: @item, status: :updated, location: @item }
      else 
        format.html { render action: "update" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @items = Item.all
    if !current_checkout.nil?
      @checkout_item = current_checkout.checkout_items.new
    end

    @item = Item.find(params[:id])
    # instead of just destroying, go and notify users of removal
    @item.checkout_items.destroy_all
    @item.destroy
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :notes, :age, :condition, :quantity, :price, :image, :category_id, :total)
  end

  def item_edit_params
    params.require(:item).permit(:name, :description, :notes, :age, :condition, :quantity, :price, :image, :category_id, :total, :unavailable)
  end
end