class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url = "#{ENV['HOSTNAME']}/login"
    mail(to: @user.email, subject: 'Welcome to My Sign up Site')
  end
end
