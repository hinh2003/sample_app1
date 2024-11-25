# frozen_string_literal: true

# The User model represents a user in the application.
# It is responsible for handling user authentication, registration,
# profile management, and other user-related functionality.
# This model is associated with several other models like `Post`, `Relationship`,
# and more. It uses features like secure password authentication and
# token generation for password resets.
module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Ruby on Rails Tutorial Sample App' # Variable assignment
    if page_title.empty? # Boolean test
      base_title # Implicit return
    else
      "#{page_title} | #{base_title}" # String concatenation
    end
  end
end
