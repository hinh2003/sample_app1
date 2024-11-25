# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Rails.backtrace_cleaner.add_silencer { |line| /my_noisy_library/.match?(line) }

Rails.backtrace_cleaner.remove_silencers! if ENV['BACKTRACE']
