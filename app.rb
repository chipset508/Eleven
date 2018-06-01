require 'sinatra'

get '/' do
  'yo bitch'
end

post '/new_comment' do
  JSON.parse(params[:payload])
end
