class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :current_checkout

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def current_checkout
    if not current_user
      nil
    elsif !@current_user.current_checkout_id.nil?
      c = Checkout.find(@current_user.current_checkout_id)
      if c.user_id != @current_user.id
        raise "User does not own the checkout under their current_checkout_id."
      else
        return c
      end
    else
      c = Checkout.create(user_id: @current_user.id, status: 0)
      current_user.current_checkout_id = c.id
      return c
    end
  end

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if !session[:user_id].nil?
    rescue ActiveRecord::RecordNotFound => ex
      session[:user_id] = nil
      current_user
    end
  end 

  def require_user
    redirect_to '/login' unless current_user
  end

  def require_admin
    render_404 unless current_user && current_user.admin?
  end
end
