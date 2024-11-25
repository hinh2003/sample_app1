# frozen_string_literal: true

# The User model represents a user in the application.
# It is responsible for handling user authentication, registration,
# profile management, and other user-related functionality.
# This model is associated with several other models like `Post`, `Relationship`,
# and more. It uses features like secure password authentication and
# token generation for password resets.
class PasswordResetsController < ApplicationController
  before_action :user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update] # Case (1)

  def new; end

  def edit; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email not found'
      render 'new'
    end
  end

  def update
    if params[:user][:password].empty? # Case (3)
      handle_empty_password
    elsif @user.update(user_params) # Case (4)
      handle_successful_update
    else
      render 'edit' # Case (2)
    end
  end

  private

  # Lấy thông tin người dùng từ email
  def user
    @user = User.find_by(email: params[:email])
  end

  # Kiểm tra tính hợp lệ của người dùng
  def valid_user
    return if @user&.activated?&.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  # Kiểm tra nếu token hết hạn
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'Password reset has expired.'
    redirect_to new_password_reset_url
  end

  # Định nghĩa phương thức để xử lý các tham số user
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def handle_empty_password
    @user.errors.add(:password, "can't be empty")
    render 'edit'
  end

  def handle_successful_update
    log_in @user
    @user.update(reset_digest: nil)
    flash[:success] = 'Password has been reset.'
    redirect_to @user
  end
end
