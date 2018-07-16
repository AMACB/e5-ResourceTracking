require 'bcrypt'

class UsersController < ApplicationController
  before_action :require_user, only: [:confirm_email, :show, :email_resend]

  def new
    redirect_to '/' if current_user
    @user = User.new
  end

  def create
    redirect_to '/' if current_user
    @user = User.new(user_params)
    if @user.save
      UserMailer.email_confirmation(@user).deliver
      session[:user_id] = @user.id
      redirect_to '/'
    else
      flash[:error] = @user.errors.full_messages
      redirect_to '/signup'
    end
  end

  def show
    current_user
    @require_email = params[:require_email]
    @show_tab = params[:show_tab]
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

  def email_resend
    if !current_user.email_confirmed
      current_user.generate_confirmation_token
      current_user.save
      UserMailer.email_confirmation(current_user).deliver
    end
  end

  def password_reset
    redirect_to '/' and return if current_user
  end

  def password_reset_send
    redirect_to '/' and return if current_user
    user = User.find_by_email(params[:email])
    if !user.nil?
      token = SecureRandom.urlsafe_base64.to_s
      UserMailer.password_reset(user, token).deliver
      user.password_reset_token_digest = BCrypt::Password.create(token)
      user.password_reset_token_expires_at = Time.zone.now + 1.days
      user.save
    end
    flash[:success] = 'An email was sent to the email address entered (if an account is associated with it) containing password reset instructions.'
    redirect_to password_reset_path
  end

  def password_reset_final
    redirect_to '/' and return if current_user
    if params[:password_reset_token].nil? or params[:user_id].nil?
      flash[:error] = 'Invalid password reset URL.'
      redirect_to password_reset_path and return
    end
    @user = User.find_by_id(params[:user_id])
    @password_reset_token = params[:password_reset_token]

    if @user.nil? || @user.password_reset_token_digest.nil? || Time.zone.now > @user.password_reset_token_expires_at
      flash[:error] = 'Invalid password reset URL.'
      redirect_to password_reset_path and return
    end

    if BCrypt::Password.new(@user.password_reset_token_digest) == @password_reset_token
      flash[:success] = 'Valid password reset URL!'
    else
      flash[:error] = 'Invalid password reset URL.'
      redirect_to password_reset_path
    end
  end

  def password_reset_update
    pass = params.require(:user).permit(:password, :password_confirmation)
    auth = params.require(:user).permit(:user_id, :password_reset_token)
    @user = User.find_by_id(auth[:user_id])
    @password_reset_token = auth[:password_reset_token]

    if @user.nil?
      flash[:error] = 'Invalid password reset URL.'
      redirect_to password_reset_path and return
    end

    if BCrypt::Password.new(@user.password_reset_token_digest) == @password_reset_token
      @user.update(pass)
      if @user.save
        flash[:success] = 'Password reset succesfully! You can now log in with your new password.'
        @user.password_reset_token_digest = nil
        @user.save
        redirect_to password_reset_path
      else
        flash[:error] = 'Errors occurred: ' + @user.errors.full_messages.to_sentence
        redirect_to password_reset_path
      end
    end
  end

  def update_email_notifs
    current_user
    @current_user.receive_email_notifications = params[:receive_email_notifications]
    if @current_user.save
      redirect_to profile_path(show_tab: "notifications")
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
