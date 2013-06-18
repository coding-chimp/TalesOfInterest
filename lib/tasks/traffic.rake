namespace :traffic do
  desc "Updates today's traffic"
  task update_today: :environment do
    Traffic.update_today
  end

  desc "Updates the traffic history"
  task update_history: :environment do
    Traffic.update_history
  end
end