class CreatePullRequestService

  attr_reader :params

  def self.call(params)
    self.new(params).call
  end

  def initialize(params)
    @params = params
  end

  def call
    channel = "##{params['channel_name']}"
    author_user_name = params['user_name']

    return unless valid_channel?(channel) && valid_user(author_user_name)

    urls= URI.extract(params['text'])
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

  def valid_user(user_name)
    ENV['BLACK_LIST_SLACK_USER'].split(',').include?(user_name)
  end

  def valid_channel?(channel)
    ENV['WHITELIST_SLACK_CHANNEL'].split(',').include?(channel)
  end
end
