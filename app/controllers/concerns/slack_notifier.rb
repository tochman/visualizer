module SlackNotifier
  extend ActiveSupport::Concern

  def self.notify(file, message)
    client = Slack::Web::Client.new
    client.files_upload(
        channels: ENV.fetch('SLACK_CHANNEL'),
        as_user: true,
        file: Faraday::UploadIO.new("public/#{file}", 'image/png'),
        title: 'Report',
        filename: 'report.png',
        initial_comment: message
    )
  end

  def self.notify_hook(hook, image_path, message)
    client = Slack::Notifier.new hook
    client.ping 'Google Analytics Visualizer report',
                attachments: [{
                    image_url: image_path,
                    initial_comment: message
                }]
  end

end