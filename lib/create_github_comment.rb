class CreateGithubComment
  attr_accessor :content

  GITHUB_ACTIONS = %w'created submitted'

  def self.call(content)
    self.new(content).call
  end

  def initialize(content)
    @content = content
  end

  def call
    case content['action']
    when 'created'
      create_created_comment
    when 'submitted'
      create_submitted_comment
    else

    end
  end

  private

  def create_submitted_comment
    body = content['review']['body']
    html_url = content['review']['html_url']
    author_name = content['review']['user']['login']
    if body.present?
      GithubComment.create(body: body, html_url: html_url, author_name: author_name)
    end
  end

  def create_created_comment
    created_content = content['comment'] || content['issue']
    body = created_content['body']
    html_url = created_content['html_url']
    author_name = created_content['user']['login']

    if body.present?
      GithubComment.create(body: body, html_url: html_url, author_name: author_name)
    end
  end
end
