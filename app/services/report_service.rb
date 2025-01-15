# frozen_string_literal: true

# this is ReportService
class ReportService
  def self.send_daily_report
    yesterday = Time.zone.yesterday

    new_users = count_new_users(yesterday)
    new_posts = count_new_posts(yesterday)
    new_comment = count_new_comments(yesterday)
    most_commented_message, micropost_url, comment_count = fetch_most_commented_post(yesterday)

    report_message = build_report_message(yesterday, new_users, new_posts, new_comment, most_commented_message)
    send_to_slack(report_message)
  end

  def self.count_new_users(date)
    User.newly_registered_yesterday(date).count
  end

  def self.count_new_posts(date)
    Micropost.new_posts_yesterday(date).count
  end

  def self.count_new_comments(date)
    Micropost.new_comments_yesterday(date).count
  end

  def self.fetch_most_commented_post(date)
    most_commented_micropost = Micropost.most_commented_yesterday(date)

    if most_commented_micropost.empty?
      [no_comments_message, '', 0]
    else
      most_commented_parent_id = most_commented_micropost.max_by { |_, count| count }.first
      comment_count = most_commented_micropost[most_commented_parent_id]
      micropost = Micropost.find(most_commented_parent_id)
      micropost_url = micropost_url(micropost)

      message = build_most_commented_message(micropost, comment_count, micropost_url)
      [message, micropost_url, comment_count]
    end
  end

  def self.no_comments_message
    'Không có bài viết nào có comment hôm qua.'
  end

  def self.build_most_commented_message(micropost, count, url)
    <<~MSG
      Bài viết có ID #{micropost.id} có nhiều comment nhất với #{count} comment.
      URL bài viết: #{url}
    MSG
  end

  def self.micropost_url(micropost)
    "http://127.0.0.1:3000/microposts/#{micropost.id}"
  end

  def self.build_report_message(yesterday, new_users, new_posts, new_comment, most_commented_message)
    <<~REPORT
      Báo cáo hàng ngày (#{yesterday.strftime('%Y-%m-%d')}):
      - Số người dùng mới đăng ký hôm qua: #{new_users}
      - Số bài đăng mới tạo hôm qua: #{new_posts}
      - Số comment mới tạo hôm qua: #{new_comment}
      #{most_commented_message}
    REPORT
  end

  def self.send_to_slack(message)
    client = Slack::Web::Client.new
    client.chat_postMessage(channel: '#social', text: message, as_user: true)
  end
end
