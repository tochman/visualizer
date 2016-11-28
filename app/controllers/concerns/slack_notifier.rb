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

end