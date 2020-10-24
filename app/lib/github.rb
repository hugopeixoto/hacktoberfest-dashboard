# frozen_string_literal: true

module Github
  PULL_REQUEST_QUERY = <<~GRAPHQL
    query($nodeId:ID!) {
      node(id:$nodeId) {
        ... on User {
          pullRequests(states: [OPEN, MERGED, CLOSED], last: 100) {
            nodes {
              id
              databaseId
              title
              body
              url
              createdAt
              merged
              reviewDecision
              repository {
                url
                databaseId
                repositoryTopics(first: 100) {
                  edges {
                    node {
                      topic {
                        name
                      }
                    }
                  }
                }
              }
              labels(first: 100) {
                edges {
                  node {
                    name
                  }
                }
              }
            }
          }
        }
      }
    }
  GRAPHQL

  def self.user(user)
    HTTParty.get(
      user.github_api_url,
      headers: {
        Accept: 'application/vnd.github.mercy-preview+json',
        Authorization: "token #{ENV['GITHUB_TOKEN']}"
      }
    ).parsed_response
  end

  def self.pull_requests(node_id)
    HTTParty.post(
      'https://api.github.com/graphql',
      body: { query: PULL_REQUEST_QUERY, variables: { nodeId: node_id } }.to_json,
      headers: {
        Authorization: "bearer #{ENV['GITHUB_TOKEN']}",
        'Content-Type': 'application/json'
      }
    ).parsed_response
  end
end
