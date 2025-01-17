every 1.day, at: '8:00 am', tz: 'Asia/Ho_Chi_Minh' do
  runner 'ReportService.send_daily_report'
end