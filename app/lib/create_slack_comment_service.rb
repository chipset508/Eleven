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
    case github_comment.comment_status
    when 'created'

    else
      normal_comment
    end
  end

  private

  def normal_comment
    "<#{github_comment.html_url}|NEW COMMENT> #{mentions}\n\n" +
     "#{body}"
  end

  def mentions
    github_mentions = body.split.uniq.select { |word| word.start_with?('@') }
    github_mentions = github_mentions
                        .map { |p| JSON.parse(ENV["USER_MAPPING"])[p] }
                        .compact
                        .join(' ')

    github_mentions.present? ? "<#{github_mentions}>" : ''
  end
end
