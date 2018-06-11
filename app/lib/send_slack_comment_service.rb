require 'slack-ruby-client'
require 'dotenv/load'

require 'require_all'
require_all './app/models/'
require_all './app/lib/'

class SendSlackCommentService

  def self.call(comment_id)
    self.new(comment_id).call
  end

  def initialize(comment_id)
    @comment_id = comment_id
  end

  def call
    github_comment = GithubComment.find_by(id: @comment_id)
    pull_request = PullRequest.where(url: github_comment.try(:pr_url)).last
    return false unless github_comment && pull_request

    slack_comment = CreateSlackComment.call(github_comment)
    # Slack.configure do |config|
    #   config.token = ENV['SLACK_API_TOKEN']
    # end
    client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
    client.chat_postMessage(
      channel: ENV['SLACK_CHANNEL'],
      attachments: [
      {
        color: RandomColor.call,
        pretext: slack_comment,
        text: github_comment.body,
      }
    ],
      as_user: true,
      thread_ts: pull_request.thread_ts
    )

    github_comment.update(status: true)
  end
end
