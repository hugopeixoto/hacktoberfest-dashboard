class HomeController < ApplicationController
  def index
    @users = User.active.order(:github_username).includes(:user_statistic)

    @tagged_issues_url = "https://github.com/search?#{{
      q: [
        "label:hacktoberfest",
        "state:open",
      ].concat(
        @users.map { |u| "user:#{u.github_username}" }
      ).join(" "),
      type: "Issues",
    }.to_query}"

    @issues_url = "https://github.com/search?#{{
      q: [
        "state:open",
      ].concat(
        @users.map { |u| "user:#{u.github_username}" }
      ).join(" "),
      type: "Issues",
    }.to_query}"
  end

  def register
    user = User.create!(params.permit(:github_username))

    user.update(active: true, payload: Github.user(user))

    redirect_to root_path
  end
end
