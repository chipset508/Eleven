class PullRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :pull_requests do |t|
      t.string :url
      t.string :author_id
      t.string :author_user_name
      t.string :thread_ts
    end
  end
end
