namespace :downloads do
  desc "Updates today's downloads"
  task update_today: :environment do
    today = Date.today
    DownloadData.update(today)
    EpisodeAnalytics.update
  end

  desc "Updates yesterday's downloads"
  task update_yesterday: :environment do
    yesterday = Date.today - 1
    DownloadData.update(yesterday)
    EpisodeAnalytics.update
  end

  desc "Updates the download history"
  task update_last_few_months: :environment do
    today = Date.today
    start = today - 62
    for date in start..today do
      DownloadData.update(date)
    end
    EpisodeAnalytics.update
  end
end
