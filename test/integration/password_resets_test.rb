# frozen_string_literal: true

require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end
  test 'password resets' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
    invalid_email
    valid_email
    password_reset_form
  end

  # Invalid email test
  def invalid_email
    post password_resets_path, params: { password_reset: { email: '' } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
  end

  # Valid email test
  def valid_email
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  # Password reset form tests
  def password_reset_form
    user = assigns(:user)
    wrong_email
    inactive_user(user)
    right_email_wrong_token(user)
    right_email_right_token(user)
    invalid_password_and_confirmation(user)
    empty_password(user)
    valid_password(user)
  end

  # Wrong email test
  def wrong_email
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url
  end

  # Inactive user test
  def inactive_user(user)
    user.update(activated: !user.activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.update(activated: !user.activated)
  end

  # Right email, wrong token test
  def right_email_wrong_token(user)
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
  end

  # Right email, right token test
  def right_email_right_token(user)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email
  end

  # Invalid password & confirmation test
  def invalid_password_and_confirmation(user)
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: 'foobaz',
                            password_confirmation: 'barquux' } }
    assert_select 'div#error_explanation'
  end

  # Empty password test
  def empty_password(user)
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: '',
                            password_confirmation: '' } }
    assert_select 'div#error_explanation'
  end

  # Valid password & confirmation test
  def valid_password(user)
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password: 'foobaz',
                            password_confirmation: 'foobaz' } }
    assert logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
