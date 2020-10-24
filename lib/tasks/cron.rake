# frozen_string_literal: true

namespace :cron do
  desc 'Update user statistics'
  task stats: :environment do
    UpdateUserStatistics.update_users
    UpdateUserStatistics.new_pull_requests
  end
end
