# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Settings.create!(:site_name => "My Awesome Podcast Network", :posts_per_page => 5, :feed_email => "mail@example.com")

User.create!(:email => "user@example.com", :password => "password")
