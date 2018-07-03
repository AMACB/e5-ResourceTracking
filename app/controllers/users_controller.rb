class UsersController < ApplicationController
  before_action :require_user, only: [:confirm_email, :show]

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

  def show
    current_user
  end

  def confirm_email
    if current_user.email_confirmed
      @confirmed = 2
    elsif @current_user.confirm_token == params[:token]
      @current_user.email_confirmed = true
      @current_user.confirm_token = nil
      @current_user.save
      @confirmed = 1
    else
      @confirmed = 0
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
