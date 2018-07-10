class ItemsController < ApplicationController
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy, :manage]
  after_action :update_available, only: [:edit]

  def index
    @filters = params.permit(:category, :q, :date_begin, :date_end).to_h

    if params[:category].blank?
      @items = Item.all
      @category_name = "All"
    else
      cat = Category.find_by(id: params[:category])
      @category_name = cat.nil? ? nil : cat.name
      if cat.nil?
        @items = []
      else
        @items = cat.items
      end
    end

    if not params[:q].nil?
      @items = @items.select do |i|
        nmdc = i.name.downcase
        select = false
        if nmdc.include? params[:q].downcase
          select = true
        end
        params[:q].split(" ").each do |t|
          if nmdc.include? t.downcase
            select = true
          end
        end
        select
      end
    end

    if !params[:date_begin].nil? and !params[:date_end].nil?
      # @items = @items.available_between(params[:date_begin], params[:date_end])
    end

    if !current_checkout.nil?
      @checkout_item = current_checkout.checkout_items.new
      @checked_out_items = Array.new
      current_checkout.checkout_items.each do |i|
        @checked_out_items.push(i.item_id)
      end
    end
  end

  def catalog
    @categories = Category.all
  end

  def manage
    @items = Item.all
    @new_item = Item.new
    @categories = Category.all
  end

  def editform
    @item = Item.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Item created successfully"}
        format.js
        format.json { render json: @item, status: :updated, location: @item }
      else
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
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
        format.html { redirect_to @item, notice: "Item edited successfully" }
        format.js
        format.json { render json: @item, status: :updated, location: @item }
      else
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
    params.require(:item).permit(:name, :description, :notes, :age, :quantity, :price, :image, :category_id, :total, :unavailable)
  end

  def item_edit_params
    params.require(:item).permit(:name, :description, :notes, :age, :quantity, :price, :image, :category_id, :total, :unavailable)
  end
end