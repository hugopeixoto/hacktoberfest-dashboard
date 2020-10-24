# frozen_string_literal: true

class PullRequest < ApplicationRecord
  belongs_to :repository
  belongs_to :user

  START_DATE = DateTime.parse('2020-10-01T00:00:00Z')
  FINISH_DATE = DateTime.parse('2020-11-01T00:00:00Z')
  OPTIN_CUTOFF = DateTime.parse('2020-10-03T12:00:00Z')

  def counts_for_hacktoberfest?
    return false unless (START_DATE..FINISH_DATE).cover?(requested_at)
    return false if labels.include?('spam')
    return false if labels.include?('invalid')

    return true if requested_at < OPTIN_CUTOFF

    labels.include?('hacktoberfest-accepted') ||
      (
        repository_topics.include?('hacktoberfest') &&
        (merged? || approved?)
      )
  end

  def merged?
    payload['merged'] == true
  end

  def approved?
    payload['reviewDecision'] == 'APPROVED'
  end

  def requested_at
    DateTime.parse(payload['createdAt'])
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
