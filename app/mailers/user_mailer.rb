class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url = "#{ENV['HOSTNAME']}/login"
    mail(to: @user.email, subject: 'Welcome to My Sign up Site')
  end

  def recovery_email
    @user = params[:user]
    @url = "#{ENV['HOSTNAME']}/recovery?token=#{@user.token}"
    mail(to: @user.email, subject: 'Reset your password!')
  end
end
