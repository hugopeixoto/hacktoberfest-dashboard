class CreateStatistics < ActiveRecord::Migration[6.0]
  def change
    create_table :user_statistics, id: :uuid do |t|
      t.references :user, type: :uuid, index: { unique: true }, foreign_key: true, null: false
      t.integer :pull_requests, null: false
    end
  end
end
