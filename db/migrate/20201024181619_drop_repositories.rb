class DropRepositories < ActiveRecord::Migration[6.0]
  def change
    remove_column :pull_requests, :repository_id

    drop_table :repositories
  end
end
