class PullRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :pull_requests do |t|
      t.string :url
      t.string :author
      t.string :slack_id
    end
  end
end
