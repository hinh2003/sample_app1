# frozen_string_literal: true

# this is TestErrorController
class TestErrorController < ApplicationController
  def test_error
    raise StandardError, 'Test error for Slack 123121'
  end
end
