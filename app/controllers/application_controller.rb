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
      Checkout.find(@current_user.current_checkout_id)
    else
      Checkout.new(user_id: @current_user.id, status: 0)
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if !session[:user_id].nil?
  end 

  def require_user
    redirect_to '/login' unless current_user
  end

  def require_admin
    render_404 unless current_user && current_user.admin?
  end
end
