class UserMailer < ApplicationMailer
  default from: "amacbtest@gmail.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome!')
  end

  def email_confirmation(user)
    @user = user
    mail(to: @user.email, subject: 'Verify Your Email - APRD Resource Management')
  end

  def password_reset(user, token)
    @user = user
    @token = token
    mail(to: @user.email, subject: "Password Reset - APRD Resource Management")
  end

  def test_email(user)
    @user = user
    mail(to: @user.email, subject: 'Test Email')
  end
end
