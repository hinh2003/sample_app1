# frozen_string_literal: true

namespace :notify do
  desc 'Send daily 14h notification'
  task send_daily_notification: :environment do
    ReportService.send_daily_report
  end
end
