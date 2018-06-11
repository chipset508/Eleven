class CreateSlackComment
  attr_accessor :github_comment

  def self.call(github_comment)
    self.new(github_comment).call
  end

  def initialize(github_comment)
    @github_comment = github_comment
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
    "<@UAFMF4XG9>"+
    "[<#{github_comment.html_url}|New comment added>]\n" +
     "#{github_comment.body}"
  end
end
