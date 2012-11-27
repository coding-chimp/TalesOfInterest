# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Podcasts
@recordcase = Podcast.create!(:name => "Recordcase", :description => "A podcast about music.")
@celluloid = Podcast.create!(:name => "Celluloid", :description => "A podcast about movies.")

# Episodes Recordcase
Episode.create!(:podcast => @recordcase, :number => 1, :title => "GEMA, GVL und CCmixter", :description => "", :episode_url => "http://www.talesofinterest.de/podcasts/recordcase001.mp3", :created_at => "2010-09-26")
Episode.create!(:podcast => @recordcase, :number => 2, :title => "Relax and Enjoy", :description => "", :episode_url => "http://www.talesofinterest.de/podcasts/recordcase002.mp3", :created_at => "2010-10-12")
Episode.create!(:podcast => @recordcase, :number => 3, :title => "be myself", :description => "", :episode_url => "http://www.talesofinterest.de/podcasts/recordcase003.mp3", :created_at => "2010-11-21")
Episode.create!(:podcast => @recordcase, :number => 4, :title => "Spanish Jazz", :description => "", :episode_url => "http://www.talesofinterest.de/podcasts/recordcase004.mp3", :created_at => "2010-12-05")
Episode.create!(:podcast => @recordcase, :number => 5, :title => "Survive", :description => "", :episode_url => "http://www.talesofinterest.de/podcasts/recordcase005.mp3", :created_at => "2011-09-24")
Episode.create!(:podcast => @recordcase, :number => 6, :title => "John Williams", :description => "", :episode_url => "http://www.talesofinterest.de/podcasts/recordcase006.mp3", :created_at => "2011-11-16")
Episode.create!(:podcast => @recordcase, :number => 7, :title => "John Williams die Zweite", :description => "", :episode_url => "http://www.talesofinterest.de/podcasts/recordcase007.mp3", :created_at => "2012-01-01")
Episode.create!(:podcast => @recordcase, :number => 8, :title => "Alan Silvestri", :description => "", :episode_url => "http://www.talesofinterest.de/podcasts/recordcase008.mp3", :created_at => "2012-03-12")

# Episodes Celluloid
Episode.create!(:podcast => @celluloid, :number => 1, 	:title => "Pulp Fiction: Tarantino", 																:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid001.m4a", :created_at => "2010-09-26")
Episode.create!(:podcast => @celluloid, :number => 2, 	:title => "Alfred Hitchcock und Der unsichtbare Dritte", 											:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid002.m4a", :created_at => "2010-10-13")
Episode.create!(:podcast => @celluloid, :number => 3, 	:title => "David Fincher and The Game.", 															:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid003.m4a", :created_at => "2010-11-21")
Episode.create!(:podcast => @celluloid, :number => 4, 	:title => "Stanley Kubrick und seine Space Opera!",													:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid004.m4a", :created_at => "2010-12-05")
Episode.create!(:podcast => @celluloid, :number => 5, 	:title => "Ivan Reitmann und wie man am besten Geister auf der Leinwand faengt", 					:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid005.m4a", :created_at => "2011-04-13")
Episode.create!(:podcast => @celluloid, :number => 6, 	:title => "Alien und sein Schoepfer Ridley Scott", 													:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid006.m4a", :created_at => "2011-06-26")
Episode.create!(:podcast => @celluloid, :number => 7, 	:title => "Ian Flemmings- Bond,,,, James Bond", 													:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid007.m4a", :created_at => "2011-06-30")
Episode.create!(:podcast => @celluloid, :number => 8, 	:title => "Christopher Nolan: Memento und Batman begins", 											:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid008.m4a", :created_at => "2011-07-10")
Episode.create!(:podcast => @celluloid, :number => 9, 	:title => "Darren Aronofsky Black Swan / The Wrestler",												:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid009.m4a", :created_at => "2011-09-21")
Episode.create!(:podcast => @celluloid, :number => 10, 	:title => "Steven Spielberg and the green little thing", 											:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid010.m4a", :created_at => "2011-11-16")
Episode.create!(:podcast => @celluloid, :number => 11, 	:title => "George Lucas Star Wars Saga (oder warum man keine schlechten Prequels drehen sollte)",	:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid011.m4a", :created_at => "2011-11-17")
Episode.create!(:podcast => @celluloid, :number => 12, 	:title => "Robert Zemeckis und Back to the future", 												:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid012.m4a", :created_at => "2012-01-03")
Episode.create!(:podcast => @celluloid, :number => 13, 	:title => "Merry Christmas und TOI lieblings Weihnachtsfilme", 										:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid013.m4a", :created_at => "2012-01-03")
Episode.create!(:podcast => @celluloid, :number => 14, 	:title => "Bud Spencer & Terence Hill",																:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid014.m4a", :created_at => "2012-03-12")
Episode.create!(:podcast => @celluloid, :number => 15, 	:title => "Peter Jackson", 																			:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid015.m4a", :created_at => "2012-06-02")
Episode.create!(:podcast => @celluloid, :number => 16,	:title => "Joss Whedon und The Avengers", 															:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid016.m4a", :created_at => "2012-06-22")
Episode.create!(:podcast => @celluloid, :number => 17,	:title => "Charlie Chaplin", 																		:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid017.m4a", :created_at => "2012-07-20")
Episode.create!(:podcast => @celluloid, :number => 18,	:title => "Guy Ritchie",																			:description => "", :episode_url => "http://www.talesofinterest.de/podcasts/celluloid018.m4a", :created_at => "2012-10-19")

# Pages
Page.create!(:titel => "About")
Page.create!(:titel => "Impressum")

# Blogroll
Blogroll.create!(:name => "Code-Chimp", :url => "http://code-chimp.org", :description => "Bastians Tech-Blog")
Blogroll.create!(:name => "Movie-Trivia of the Day", :url => "http://movietriviaoftheday.com/", :description => "Bastians Trivia-Seite")
Blogroll.create!(:name => "Kinosaal Deluxe", :url => "http://kinosaal-deluxe.de/", :description => "Dimitars Filmrezensionen")
Blogroll.create!(:name => "Der Lautsprecher", :url => "http://der-lautsprecher.de/", :description => "Podcast ueber Podcasting von Tim Pritlove")