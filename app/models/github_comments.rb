class GithubComment < ActiveRecord::Base
  def first_comment_in_thread?
    GithubComment.where(thread_ts: thread_ts, author_name: author_name).count == 1
  end
end
