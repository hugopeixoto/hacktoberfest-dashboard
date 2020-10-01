class User < ApplicationRecord
  scope :active, -> { where(active: true) }
  has_one :user_statistic

  def github_url
    "https://github.com/#{github_username}"
  end
end
