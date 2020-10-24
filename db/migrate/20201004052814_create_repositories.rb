class CreateRepositories < ActiveRecord::Migration[6.0]
  def change
    create_table :repositories, id: :uuid do |t|
      t.string :url, null: false, index: { unique: true }

      t.json :payload

      t.timestamps
    end

    create_table :pull_requests, id: :uuid do |t|
      t.string :url, null: false, index: { unique: true }

      t.references :repository, type: :uuid, null: false, foreign_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.json :payload

      t.timestamps
    end

    change_table :users do |t|
      t.json :payload
    end
  end
end
