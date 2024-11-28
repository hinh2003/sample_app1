# frozen_string_literal: true

# The User model represents a user in the application.
# It is responsible for handling user authentication, registration,
# profile management, and other user-related functionality.
# This model is associated with several other models like `Post`, `Relationship`,
# and more. It uses features like secure password authentication and
# token generation for password resets.
class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      process_authenticated_user(user)
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def create_third_party
    user = User.create_third_party(request.env['omniauth.auth'])
    log_in(user)
    redirect_back_or user
  end

  private

  def process_authenticated_user(user)
    if user.activated?
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      message = 'Account not activated. '
      message += 'Check your email for the activation link.'
      flash[:warning] = message
      redirect_to root_url
    end
  end
end
