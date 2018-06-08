class ReCreateGithubCommentTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :github_comments
    create_table :github_comments do |t|
      t.string :body
      t.string :html_url
      t.boolean :status
      t.string :comment_status
      t.string :author_name
    end
  end
end
