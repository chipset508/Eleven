class ChangeCommentStatusToState < ActiveRecord::Migration[5.2]
  def change
    rename_column :github_comments, :comment_status, :state
  end
end
