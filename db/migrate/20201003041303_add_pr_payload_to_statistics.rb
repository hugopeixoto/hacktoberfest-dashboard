class AddPrPayloadToStatistics < ActiveRecord::Migration[6.0]
  def change
    change_table :user_statistics do |t|
      t.json :pull_requests_payload
    end
  end
end
