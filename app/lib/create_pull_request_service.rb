class CreatePullRequestService

  attr_reader :params

  def self.call(params)
    self.new(params).call
  end

  def initialize(params)
    @params = params
  end

  def call
    byebug
    channel = "##{params['channel_name']}"

    return unless valid_channel?(channel)

    urls= URI.extract(params['text'])
    author_user_name = params['user_name']
    author_id = params['user_id']
    thread_ts = params['timestamp']

    if urls
      urls.each do |url|
        next if URI(url).host != 'github.com'

        PullRequest.create(
          url: url.split('/files')[0],
          author_id: author_id,
          author_user_name:  author_user_name,
          thread_ts: thread_ts,
          channel: channel,
          )
      end
    end
  end

  private

  def valid_channel?(channel)
    ENV['WHITELIST_SLACK_CHANNEL'].split(',').include?(channel)
  end
end
