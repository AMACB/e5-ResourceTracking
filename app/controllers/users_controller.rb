class UsersController < ApplicationController
  def new
    redirect_to '/' if current_user
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to '/'
    else
      flash[:error] = @user.errors.full_messages
      redirect_to '/signup'
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
