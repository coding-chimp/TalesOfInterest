namespace :downloads do
  desc "Updates today's traffic"
  task update_today: :environment do
    today = Date.today
    DownloadData.update(today)
  end

  desc "Updates yesterday's traffic"
  task update_yesterday: :environment do
    yesterday = Date.today - 1
    DownloadData.update(yesterday)
  end

  desc "Updates the traffic history"
  task update_last_month: :environment do
    today = Date.today
    start = today - 31
    for date in start..today do
      DownloadData.update(date)
    end
  end
end