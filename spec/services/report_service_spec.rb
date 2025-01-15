# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ReportService, type: :service do
  describe '.send_daily_report' do
    let(:yesterday) { Time.zone.yesterday }

    before do
      allow(ReportService).to receive(:send_to_slack)
    end

    it 'calls send_to_slack with the correct message' do
      new_users = 5
      new_posts = 10
      new_comment = 15
      most_commented_message = 'Bài viết có ID 1 có nhiều comment nhất với 10 comment.'

      mock_report_service_methods(new_users, new_posts, new_comment, most_commented_message)
      report_message = build_expected_report_message(new_users, new_posts, new_comment, most_commented_message)
      ReportService.send_daily_report

      expect(ReportService).to have_received(:send_to_slack).with(report_message)
    end
  end
  describe 'count_data' do
    include_examples 'report service spec data'
  end
end

def mock_report_service_methods(new_users, new_posts, new_comment, most_commented_message)
  allow(ReportService).to receive(:count_new_users).and_return(new_users)
  allow(ReportService).to receive(:count_new_posts).and_return(new_posts)
  allow(ReportService).to receive(:count_new_comments).and_return(new_comment)
  allow(ReportService).to receive(:fetch_most_commented_post).and_return([most_commented_message, 'http://example.com', 10])
end

def build_expected_report_message(new_users, new_posts, new_comment, most_commented_message)
  <<~REPORT
    Báo cáo hàng ngày (#{Time.zone.yesterday.strftime('%Y-%m-%d')}):
    - Số người dùng mới đăng ký hôm qua: #{new_users}
    - Số bài đăng mới tạo hôm qua: #{new_posts}
    - Số comment mới tạo hôm qua: #{new_comment}
    #{most_commented_message}
  REPORT
end
