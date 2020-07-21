class UsersController < ApplicationController
  before_action :set_user, only: %i[destroy update]

  before_action :authorize, only: %i[show edit update]

  def index
    redirect_to '/profile'
  end

  def show
    @user = current_user
  end

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(user_params)
    @user.username = @user.email.split('@').first

    respond_to do |format|
      if @user.save
        UserMailer.with(user: @user).welcome_email.deliver_later
        session[:user_id] = @user.id
        format.html { redirect_to '/profile', notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to '/profile', notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        flash[:user_update_error] = @user.errors.full_messages
        format.html { redirect_to profile_edit_url }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def password_reset_request
    user = User.find_by_email(params[:email])
    redirect_to '/login', alert: 'Sorry, there is no user with this e-mail!' unless user

    user.token = SecureRandom.uuid
    user.token_created_at = DateTime.now
    user.save!
    UserMailer.with(user: user).recovery_email.deliver_later
    redirect_to '/login', notice: 'We send you an e-mail with the password recovery instructions.'
  end

  def recovery
    return redirect_to '/login', alert: 'Invalid token' unless params[:token]

    @user = User.find_by(token: params[:token])
    return redirect_to '/login', alert: 'Invalid token' unless @user

    unless @user.token_created_at + 6.hours > DateTime.now
      redirect_to '/login', alert: 'Token expired. Please request the password reset again.'
    end
    @user
  end

  def update_password
    @user = User.find_by_email(user_params[:email])
    if @user.update(user_params)
      @user.token = nil
      @user.token_created_at = nil
      @user.save!
      redirect_to '/login', notice: 'Password update.'
    else
      flash[:user_update_errors] = @user.errors.full_messages
      redirect_to recovery_url(token: @user.token)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :old_password)
  end
end
