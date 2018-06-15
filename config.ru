ENV['RACK_ENV'] ||= 'development'

require 'rubygems'
require './config/environment.rb'
require './app'

Bundler.require(:default, ENV['RACK_ENV'])
run Sinatra::Application
