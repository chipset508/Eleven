ENV['RACK_ENV'] ||= 'development'

require 'rubygems'
require './config/environment.rb'
require './app'
require 'logger'

Bundler.require(:default, ENV['RACK_ENV'])
run Sinatra::Application
