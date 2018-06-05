require 'sinatra'
require 'sinatra'
require 'sinatra/activerecord'

get '/' do
  'yo bitch'
end

post '/new_pull_request' do
  JSON.parse(params[:payload])
end
