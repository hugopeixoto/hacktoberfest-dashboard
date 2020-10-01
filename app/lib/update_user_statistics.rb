module UpdateUserStatistics
  class<<self
    def update_all
      User.active.each do |user|
        update user
      end
    end

    def update(user)
      response = HTTParty.get(
        "https://api.github.com/search/issues?q=is:pr+author:#{user.github_username}+created:>=2020-10-01",
        headers: { Accept: "application/vnd.github.v3+json" },
      )

      if user.user_statistic
        user.user_statistic.update!(pull_requests: response["total_count"])
      else
        UserStatistic.create!(user: user, pull_requests: response["total_count"])
      end
    end
  end
end
