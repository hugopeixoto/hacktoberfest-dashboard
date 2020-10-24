class PullRequest < ApplicationRecord
  belongs_to :repository
  belongs_to :user

  OPTIN_CUTOFF = DateTime.parse("2020-11-03T12:00:00Z")

  def counts_for_hacktoberfest?
    DateTime.parse(payload["createdAt"]) < OPTIN_CUTOFF || (
      repository.payload["topics"].include?("hacktoberfest") &&
      (
        payload["merged"] == true ||
        labels.include?("hacktoberfest") ||
        payload["reviewDecision"] == "APPROVED"
      )
    )
  end

  def labels
    payload
      .dig("labels", "edges")
      .map { |label| label["node"]["name"] }
  end
end
