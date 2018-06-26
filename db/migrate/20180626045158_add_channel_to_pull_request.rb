class AddChannelToPullRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :pull_requests, :channel, :string
  end
end
