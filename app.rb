before do
  content_type 'application/json'
end

get '/' do
  'yo yo'
end

post '/new_pull_request' do
  return if params['token'] != ENV['SLACK_PUT_TOKEN']
  urls= URI.extract(params['text'])
  author_user_name = params['user_name']
  author_id = params['user_id']
  thread_ts = params['timestamp']
  if urls
    urls.each do |url|
      next if URI(url).host != 'github.com'

      PullRequest.create(
        url: url,
        author_id: author_id,
        author_user_name:  author_user_name,
        thread_ts: thread_ts,
      )
      status 201
    end
  end
end

post '/new_comment' do
  content = JSON.parse(request.body.read)
  new_comment = CreateGithubComment.call(content)
  SendSlackCommentService.call(new_comment.id) if new_comment

  status 201
end
