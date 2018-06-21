class ItemsController < ApplicationController
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy, :manage]

  def index
    @items = Item.all
    if !current_checkout.nil?
      @checkout_item = current_checkout.checkout_items.new
    end
  end

  def manage
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to items_path
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
    if @item.update_attributes(item_params)
      redirect_to items_path
    else
      render 'edit'
    end
  end

  def destroy
    @items = Item.all
    if !current_checkout.nil?
      @checkout_item = current_checkout.checkout_items.new
    end

    @item = Item.find(params[:id])
    @item.destroy
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :notes, :age, :condition, :quantity, :price, :image, :category_id)
  end
end