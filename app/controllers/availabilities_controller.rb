class AvailabilitiesController < ApplicationController
  def new
    @availability = Availability.new
  end

  def create
    @availability = Availability.new(availability_params)
    if @item.save
      redirect_to @availability
    else
      render 'new'
    end
  end

  def show
    @availability = Availability.find(params[:id])
  end

  def edit
    @availability = Availability.find(params[:id])
  end

  def update
    @availability = Availability.find(params[:id])
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @availability, notice: "Availability edited successfully"}
        format.js
        format.json { render json: @availability, status: :updated, location: @availability }
      else 
        format.html { render action: "update" }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @availability = Availability.find(params[:id])
    @availability.destroy
  end

  private
  def availability_params
    params.require(:availability).permit(:available, :checked_out, :unavailable, :total)
  end
end
