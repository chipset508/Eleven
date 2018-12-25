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

    github_comment.update_attributes(thread_ts: pull_request.thread_ts)

    slack_comment_decorator = SlackCommentDecoratorService.new(github_comment)

    client = Slack::Web::Client.new
    client.chat_postMessage(
      channel: pull_request.channel,
      attachments: [
      {
        color: ColorPickerService.by_state(github_comment.state),
        pretext: slack_comment_decorator.title,
        text: slack_comment_decorator.body + slack_comment_decorator.mentions,
        mrkdwn_in: ["pretext", "text", "fields"],
      }
    ],
      as_user: true,
      thread_ts: pull_request.thread_ts
    )

    github_comment.update(status: true)
  end
end
