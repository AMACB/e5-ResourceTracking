# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def welcome_email_preview
    UserMailer.welcome_email(User.first)
  end

  def email_confirmation_preview
    UserMailer.email_confirmation(User.first)
  end

  def test_email_preview
    UserMailer.test_email(User.first)
  end

  def reset_password_preview
    UserMailer.password_reset(User.first, 'token123')
  end
end
