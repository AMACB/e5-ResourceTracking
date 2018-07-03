class UserMailer < ApplicationMailer
  default from: "amacbtest@gmail.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome!')
  end

  def email_confirmation(user)
    @user = user
    mail(to: @user.email, subject: 'Verify Your Email')
  end

  def test_email(user)
    @user = user
    mail(to: @user.email, subject: 'Test Email')
  end
end
