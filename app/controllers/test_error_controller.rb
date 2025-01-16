# frozen_string_literal: true

class TestErrorController < ApplicationController
  def test_error
    raise StandardError, "Test error for Slack"
  end
end
