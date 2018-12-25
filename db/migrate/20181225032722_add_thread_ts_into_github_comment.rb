class AddThreadTsIntoGithubComment < ActiveRecord::Migration[5.2]
  def change
    add_column :github_comments, :thread_ts, :string
  end
end
