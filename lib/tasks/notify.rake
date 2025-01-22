namespace :notify do
  desc 'Send notifications every 10 seconds for testing'
  task send_daily_notification_test: :environment do
    loop do
      puts "Sending notification at #{Time.zone.now}"

      ReportService.send_daily_report
      sleep 10
    end
  end
end
