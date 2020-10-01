class User < ApplicationRecord
  scope :active, -> { where(active: true) }
  has_one :user_statistic

  before_save :strip_username_whitespace

  def github_avatar_url
    "https://github.com/#{github_username}.png"
  end

  def github_url
    "https://github.com/#{github_username}"
  end

  def strip_username_whitespace
    self.github_username.strip!
  end
end
