ENV['RACK_ENV'] ||= 'development'

require 'rubygems'
require './config/environment.rb'
require './app'
require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

Bundler.require(:default, ENV['RACK_ENV'])
run Sinatra::Application
