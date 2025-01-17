# frozen_string_literal: true

shared_examples 'report service spec data' do
  describe '.count_new_users' do
    it 'returns the correct number of new users' do
      yesterday = Time.zone.yesterday
      allow(User).to receive(:newly_registered_yesterday).with(yesterday).and_return([double('User')])
      result = ReportService.count_new_users(yesterday)
      expect(result).to eq(1)
    end
  end
  describe '.count_new_posts' do
    it 'returns the correct number of new posts' do
      yesterday = Time.zone.yesterday

      allow(Micropost).to receive(:new_posts_yesterday).with(yesterday).and_return([double('Micropost')])

      result = ReportService.count_new_posts(yesterday)
      expect(result).to eq(1)
    end
  end
  describe '.count_new_comments' do
    it 'returns the correct number of new comments' do
      yesterday = Time.zone.yesterday
      allow(Micropost).to receive(:new_comments_yesterday).with(yesterday).and_return([double('Comment')])

      result = ReportService.count_new_comments(yesterday)
      expect(result).to eq(1)
    end
  end

end