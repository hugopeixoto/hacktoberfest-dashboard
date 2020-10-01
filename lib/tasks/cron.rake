namespace :cron do
  desc "Update user statistics"
  task stats: :environment do
    UpdateUserStatistics.update_all
  end
end
