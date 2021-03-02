require 'dotenv/load'
require 'bundler/setup'
require 'sinatra/activerecord'
require "uri"
require 'slack-ruby-client'
require 'require_all'
require_all 'app'
require 'sinatra'

ActiveRecord::Base.logger.level = 1

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end
