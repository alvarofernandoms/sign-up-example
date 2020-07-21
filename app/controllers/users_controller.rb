class UsersController < ApplicationController
  before_action :set_user, only: %i[update destroy]

  before_action :authorize, only: %i[show edit update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = current_user
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = current_user
  end

  # POST /users
  # POST /users.json
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

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      has_old_password_param = !user_params[:old_password].empty?
      if has_old_password_param && BCrypt::Password.create(user_params[:old_password]) != @user.password_digest
        wrong_password = true
      end
      if @user.update(user_params) && !wrong_password
        format.html { redirect_to '/profile', notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        @user.errors.add(:password, :not_specified, message: ': wrong password!') if wrong_password
        flash[:user_update_error] = @user.errors.full_messages
        format.html { redirect_to profile_edit_url }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :old_password)
  end
end
