every 15.minutes do
  rake "traffic:update_today"
end

every :hour do
  rake "subscribers:update"
end

every :hour do
  rake "downloads:update_today"
end

every 6.hours do
  rake "downloads:update_yesterday"
end