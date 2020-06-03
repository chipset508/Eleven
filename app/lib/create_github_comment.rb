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
    when 'closed'
      create_closed_comment
    when 'reopened'
      create_reopened_comment
    when 'assigned'
      create_assigned_action
    else
      false
    end
  end

  private

  def create_reopened_comment
    html_url = content.dig('pull_request', 'html_url') || content.dig('issue', 'html_url')
    action_by = content.dig('sender', 'login') || content.dig('pull_request', 'user', 'login')

    return false if in_black_list?(action_by)

    GithubComment.create(
      body: '',
      html_url: html_url,
      author_name: action_by,
      pr_url: html_url,
      state: 'reopened'
    )
  end

  def create_assigned_action
    html_url = content.dig('issue', 'html_url') || content.dig('pull_request', 'html_url')
    assigned_by = content.dig('sender', 'login')
    assigned_to = content.dig('assignee', 'login')

    return false if in_black_list?(assigned_by)

    GithubComment.create(
      body: "Issue assigned to @#{assigned_to}",
      html_url: html_url,
      author_name: assigned_by,
      pr_url: html_url,
      state: 'assigned'
    )
  end

  def create_closed_comment
    is_merged = content.dig('pull_request', 'merged')
    html_url = content.dig('pull_request', 'html_url') || content.dig('issue', 'html_url')
    action_by = content.dig('sender', 'login') || content.dig('pull_request', 'user', 'login')

    return false if in_black_list?(action_by)

    if is_merged
      GithubComment.create(
        body: '',
        html_url: html_url,
        author_name: action_by,
        pr_url: html_url,
        state: 'merged'
      )
    else
      GithubComment.create(
        body: '',
        html_url: html_url,
        author_name: action_by,
        pr_url: html_url,
        state: 'closed'
      )
    end
  end

  def create_submitted_comment
    body = content['review']['body']
    html_url = content['review']['html_url']
    state = content['review']['state']
    author_name = content['review']['user']['login']
    pr_url = content['pull_request']['html_url']

    unless in_black_list?(author_name) || (state == 'commented' && body.blank?)
      GithubComment.create(
        body: body,
        html_url: html_url,
        author_name: author_name,
        pr_url: pr_url,
        state: state
      )
    end
  end

  def create_created_comment
    body = content['comment']['body']
    html_url = content['comment']['html_url']
    author_name = content['comment']['user']['login']
    pr_url = if content['issue'].present?
               content.dig('issue', 'pull_request', 'html_url') ||
                 content.dig('issue', 'html_url')
             else
               content['pull_request']['html_url']
             end

    if body.present? && !in_black_list?(author_name)
      GithubComment.create(body: body, html_url: html_url, author_name: author_name, pr_url: pr_url)
    end
  end

  def in_black_list?(github_user)
    ENV['BLACK_LIST_GITHUB_USER'].split(',').include?(github_user)
  end
end
