# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ReportService, type: :service do
  describe '.send_daily_report' do
    let(:yesterday) { Time.zone.yesterday }
    let(:new_users) { 5 }
    let(:new_posts) { 10 }
    let(:new_comment) { 15 }
    let(:most_commented_message) { ReportService.build_most_commented_message(mock_micropost, 10) }

    let(:mock_micropost) { double('Micropost', id: 1) }

    before do
      allow(ReportService).to receive(:send_to_slack)
      mock_report_service_methods(new_users, new_posts, new_comment, most_commented_message)
    end

    it 'calls send_to_slack with the correct message' do
      report_message = ReportService.build_report_message(yesterday,new_users, new_posts, new_comment, most_commented_message)
      ReportService.send_daily_report

      expect(ReportService).to have_received(:send_to_slack).with(report_message)
    end
  end

  def mock_report_service_methods(new_users, new_posts, new_comment, most_commented_message)
    allow(ReportService).to receive(:count_new_users).and_return(new_users)
    allow(ReportService).to receive(:count_new_posts).and_return(new_posts)
    allow(ReportService).to receive(:count_new_comments).and_return(new_comment)
    allow(ReportService).to receive(:fetch_most_commented_post).and_return([most_commented_message, 'http://example.com', 10])
  end
end
