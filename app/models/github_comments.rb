class GithubComment < ActiveRecord::Base
  def first_comment_in_thread?
    GithubComment
      .where(thread_ts: thread_ts, author_name: author_name, state: [nil, 'commented']).count == 1
  end

  def author_of_thread?
    author_id = PullRequest.find_by(thread_ts: thread_ts).author_id

    "@#{author_id}" == JSON.parse(ENV["USER_MAPPING"])["@#{author_name}"]
  end
end
