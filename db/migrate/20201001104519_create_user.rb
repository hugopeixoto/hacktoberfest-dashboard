class CreateUser < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'

    create_table :users, id: :uuid do |t|
      t.string :github_username, index: { unique: true }
      t.boolean :active, default: false
    end
  end
end
