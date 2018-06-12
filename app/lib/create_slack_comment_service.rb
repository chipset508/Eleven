class CreateSlackComment
  attr_accessor :github_comment, :body

  def self.call(github_comment)
    self.new(github_comment).call
  end

  def initialize(github_comment)
    @github_comment = github_comment
    @body = github_comment.body
  end

  def call
    case github_comment.state
    when 'approved'
      approve_comment
    when 'changes_requested'
      change_requested_comment
    else
      normal_comment
    end
  end

  private

  def change_requested_comment
    "<#{github_comment.html_url}|:x: #{github_comment.author_name}>" +
    " #{mentions}"
  end

  def approve_comment
    "<#{github_comment.html_url}|:white_check_mark: #{github_comment.author_name}>" +
    " #{mentions}"
  end

  def normal_comment
    "<#{github_comment.html_url}|:speech_balloon: #{github_comment.author_name}>" +
    "#{mentions}"
  end

  def mentions
    github_mentions = body.split.uniq.select { |word| word.start_with?('@') }
    github_mentions = github_mentions
                        .map { |p| JSON.parse(ENV["USER_MAPPING"])[p] }
                        .compact
                        .join(' ')

    github_mentions.present? ? ". cc <#{github_mentions}>" : ''
  end
end
