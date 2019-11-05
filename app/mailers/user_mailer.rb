# app/mailer/user_mailer.rb
class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    @account = user.account

    mail to: @user.email, subject: "You have been added to the '#{@account.name}' Open Interop account"
  end
end
