require 'sinatra'
require 'sinatra'
require 'sinatra/activerecord'
require './models/pull_requests.rb'
require './models/github_comments.rb'
require "uri"
require 'dotenv/load'
require 'slack-ruby-client'

get '/' do
  'yo bitch'
end

post '/new_pull_request' do
  return if params['token'] != ENV['SLACK_PUT_TOKEN']
  urls= URI.extract(params['text'])
  author_user_name = params['user_name']
  author_id = params['user_id']
  thread_ts = params['thread_ts']
  if urls
    urls.each do |url|
      next if URI(url).host != 'github.com'

      PullRequest.create(
        url: url,
        author_id: author_id,
        author_user_name:  author_user_name,
        thread_ts: thread_ts
      )
    end
  end
end

post '/new_comment' do
  content = params
  GithubComment.create(content: content)
end

get '/hi' do
  Slack.configure do |config|
    config.token = ENV['SLACK_API_TOKEN']
  end
  client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
  client.chat_postMessage(channel: ENV['SLACK_CHANNEL'], text: 'Hello World', as_user: true, ts: '1528193018.000109')

end
