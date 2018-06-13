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
    else
      normal_comment
    end
  end

  def mentions
    github_mentions = body.split.uniq.select { |word| word.start_with?('@') }
    github_mentions = github_mentions
                        .map { |p| JSON.parse(ENV["USER_MAPPING"])[p] }
                        .compact
                        .join(' ')

    github_mentions.present? ? "\n\n cc <#{github_mentions}>" : ''
  end

  private

  def change_requested_comment
    "<#{github_comment.html_url}|:x: #{github_comment.author_name} request changed>"
  end

  def approve_comment
    "<#{github_comment.html_url}|:white_check_mark: #{github_comment.author_name} approved>"
  end

  def normal_comment
    "<#{github_comment.html_url}|:speech_balloon: #{github_comment.author_name} commented>"
  end
end
