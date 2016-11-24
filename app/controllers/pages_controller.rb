class PagesController < ApplicationController
  def index
  end

  def redirect
    client = Signet::OAuth2::Client.new({
                                            client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
                                            client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
                                            authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
                                            scope: Google::Apis::AnalyticsV3::AUTH_ANALYTICS_READONLY,
                                            redirect_uri: url_for(action: :callback)
                                        })
    binding.pry
    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new({
                                            client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
                                            client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
                                            token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
                                            redirect_uri: url_for(action: :callback),
                                            code: params[:code]
                                        })

    response = client.fetch_access_token!

    session[:access_token] = response['access_token']
    binding.pry

    redirect_to url_for(action: :analytics)
  end

  def analytics
    client = Signet::OAuth2::Client.new(access_token: session[:access_token])

    service = Google::Apis::AnalyticsV3::AnalyticsService.new

    service.authorization = client
    binding.pry

    @account_summaries = service.list_account_summaries
  end
end
