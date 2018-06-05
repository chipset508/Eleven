require 'sinatra'
require 'sinatra'
require 'sinatra/activerecord'
require '/models'

get '/' do
  'yo bitch'
end

post '/new_comment' do
  JSON.parse(params[:payload])
end
