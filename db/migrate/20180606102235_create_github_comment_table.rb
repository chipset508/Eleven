class CreateGithubCommentTable < ActiveRecord::Migration[5.2]
  def change
    create_table :github_comments do |t|
      t.string :content
      t.boolean :status
      t.string :pr_url
    end
  end
end
