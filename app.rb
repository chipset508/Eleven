require 'sinatra'

before do
  content_type 'application/json'
end

get '/' do
  'yo yo'
end

post '/new_pull_request' do
  logger.info params
  CreatePullRequestService.call(params)
end

post '/new_comment' do
  logger.info 'This is a test log'
  content = JSON.parse(request.body.read)
  new_comment = CreateGithubComment.call(content)
  SendSlackCommentService.call(new_comment.id) if new_comment

  status 201
end
