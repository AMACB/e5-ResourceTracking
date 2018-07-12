class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :current_request

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def current_request
    if not current_user
      nil
    elsif !@current_user.current_request_id.nil?
      r = Request.find(@current_user.current_request_id)
      if r.user_id != @current_user.id
        raise "User does not own the request under their current_request_id: " + r.user_id.to_s
      else
        return r
      end
    else
      r = Request.create(user_id: @current_user.id, status: 0)
      current_user.current_request_id = r.id
      return r
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
    redirect_to login_path unless current_user
  end

  def require_confirmed_user
    redirect_to profile_path(require_email: true) unless current_user && current_user.email_confirmed
  end

  def require_admin
    render_404 unless current_user && current_user.admin?
  end
end
