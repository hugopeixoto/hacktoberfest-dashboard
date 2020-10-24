# frozen_string_literal: true

module UpdateUserStatistics
  START_DATE = DateTime.parse('2020-10-01T00:00:00Z')

  class<<self
    def update_users
      User
        .active
        .where(payload: nil)
        .each do |user|
          user.update(payload: Github.user(user))
        end
    end

    def new_pull_requests
      User.active.each(&method(:new_pull_requests_for_user))
    end

    def update_repositories
      Repository.all.each(&method(:update_repository))
    end

    def update_repository(repository)
      return if repository.payload && repository.updated_at < 5.minutes.ago

      repository.update(payload: Github.repository(repository))
    end

    def new_pull_requests_for_user(user)
      Github
        .pull_requests(user.github_node_id)
        .dig('data', 'node', 'pullRequests', 'nodes')
        .select { |pr| START_DATE < DateTime.parse(pr['createdAt']) }
        .each do |pr|
          PullRequest
            .where(url: pr['url'], user: user)
            .first_or_create(payload: pr)
            .update(payload: pr)
        end
    end
  end
end
