class AddChannelIdToPullRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :pull_requests, :channel_id, :string
  end
end
