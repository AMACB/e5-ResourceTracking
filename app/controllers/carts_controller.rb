class CartsController < ApplicationController
  before_action :require_user

  def show
    @checkout_items = current_checkout.checkout_items
  end
end
