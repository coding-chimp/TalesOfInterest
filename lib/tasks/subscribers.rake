namespace :subscribers do
  desc "Updates subscribers"
  task update: :environment do
    Subscriber.update
  end
end