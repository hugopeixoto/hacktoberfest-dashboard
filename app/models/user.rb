class User < ApplicationRecord
  has_one :user_statistic
  has_many :pull_requests

  scope :active, -> { where(active: true) }

  before_save :strip_username_whitespace

  def github_avatar_url
    "https://github.com/#{github_username}.png"
  end

  def github_url
    "https://github.com/#{github_username}"
  end

  def github_api_url
    "https://api.github.com/users/#{github_username}"
  end

  def github_node_id
    Base64.strict_encode64("04:User#{payload["id"]}")
  end

  def strip_username_whitespace
    self.github_username.strip!
  end
end
