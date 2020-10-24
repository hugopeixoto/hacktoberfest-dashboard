# frozen_string_literal: true

class PullRequest < ApplicationRecord
  belongs_to :repository
  belongs_to :user

  OPTIN_CUTOFF = DateTime.parse('2020-10-03T12:00:00Z')

  def counts_for_hacktoberfest?
    DateTime.parse(payload['createdAt']) < OPTIN_CUTOFF || (
      repository_topics.include?('hacktoberfest') &&
      (
        payload['merged'] == true ||
        labels.include?('hacktoberfest') ||
        payload['reviewDecision'] == 'APPROVED'
      )
    )
  end

  def repository_topics
    payload
      .dig('repository', 'repositoryTopics', 'edges')
      .map { |topic| topic.dig('node', 'topic', 'name') }
  end

  def labels
    payload
      .dig('labels', 'edges')
      .map { |label| label.dig('node', 'name') }
  end
end
