class SlackCommentDecoratorService
  attr_accessor :github_comment, :body, :subscription

  def initialize(github_comment)
    @github_comment = github_comment
    @body = github_comment.body
    @subscription = ''
  end

  def title
    case github_comment.state
    when 'approved'
      approve_comment
    when 'changes_requested'
      @subscription = comment_subscription
      change_requested_comment
    when 'merged'
      merged_comment
    when 'closed'
      closed_comment
    when 'reopened'
      reopened_comment
    when 'assigned'
      assigned_action
    else
      @subscription = comment_subscription
      normal_comment
    end
  end

  def mentions
    return '' unless body.present?
    github_mentions = body.split.uniq.select { |word| word.start_with?('@') }

    github_mentions = github_mentions
                        .map { |p| JSON.parse(ENV["USER_MAPPING"])[p.gsub(/[^@a-zA-Z0-9\-]/,"")] }
                        .compact

    github_mentions.present? ? "\n\n cc #{mention_slack_format(github_mentions)}" : ''
  end

  def mention_slack_format(mentions)
    mentions.map{ |s| "<#{s}>" }.join(' ')
  end

  def body
    if github_comment.body.to_s.empty?
      github_comment.state.gsub('_', ' ').capitalize
    else
      github_comment.body.to_s
    end
  end

  private

  def comment_subscription
    return '' if !github_comment.first_comment_in_thread? || github_comment.author_of_thread?

    subscribe_user = JSON.parse(ENV["USER_MAPPING"])["@#{github_comment.author_name}"]
    return "\n\n <#{subscribe_user}> subscribed to this thread" if subscribe_user

    ''
  end

  def reopened_comment
    "<#{github_comment.html_url}|:unlock: #{github_comment.author_name}>"
  end

  def assigned_action
    "<#{github_comment.html_url}|:bust_in_silhouette: #{github_comment.author_name}>"
  end

  def closed_comment
    "<#{github_comment.html_url}|:closed_lock_with_key: #{github_comment.author_name}>"
  end

  def merged_comment
    "<#{github_comment.html_url}|:lock: #{github_comment.author_name}>"
  end

  def change_requested_comment
    "<#{github_comment.html_url}|:x: #{github_comment.author_name}>"
  end

  def approve_comment
    "<#{github_comment.html_url}|:white_check_mark: #{github_comment.author_name}>"
  end

  def normal_comment
    "<#{github_comment.html_url}|:speech_balloon: #{github_comment.author_name}>"
  end
end
