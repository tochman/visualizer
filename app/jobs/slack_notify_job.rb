class SlackNotifyJob < ApplicationJob
  queue_as :default

  def perform(*args)
    #binding.pry
    SlackNotifier.notify_hook(args[:hook], args[:image_url], args[:message])# if params[:hook] && Rails.env.development?

  end
end
