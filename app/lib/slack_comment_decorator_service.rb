class SlackCommentDecoratorService
  attr_accessor :github_comment, :body

  def initialize(github_comment)
    @github_comment = github_comment
    @body = github_comment.body
  end

  def title
    case github_comment.state
    when 'approved'
      approve_comment
    when 'changes_requested'
      change_requested_comment
    when 'merged'
      merged_comment
    else
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
