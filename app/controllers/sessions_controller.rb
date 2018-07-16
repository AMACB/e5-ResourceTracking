class SessionsController < ApplicationController
  def new
    redirect_to '/' if current_user
  end

  def create
    @user = User.find_by_email(params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to '/'
    else
      flash[:error] = ['Invalid email or password']
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end
end
