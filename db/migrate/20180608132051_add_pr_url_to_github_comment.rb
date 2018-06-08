class AddPrUrlToGithubComment < ActiveRecord::Migration[5.2]
  def change
    add_column :github_comments, :pr_url, :string
  end
end
