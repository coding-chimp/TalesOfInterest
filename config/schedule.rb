every 15.minutes do
  rake "traffic:update_today"
end

every :hour do
  rake "subscribers:update"
end