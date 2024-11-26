# frozen_string_literal: true

# The User model represents a user in the application.
# It is responsible for handling user authentication, registration,
# profile management, and other user-related functionality.
# This model is associated with several other models like `Post`, `Relationship`,
# and more. It uses features like secure password authentication and
# token generation for password resets.
class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def about; end

  def contact; end

  def help; end
end
