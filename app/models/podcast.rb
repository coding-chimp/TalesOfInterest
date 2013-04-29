class Podcast < ActiveRecord::Base
	include ActionView::Helpers::DateHelper

	has_many :episodes, dependent: :destroy
  attr_accessible :description, :name, :slug, :artwork, :author, :keywords, :explicit, :itunes_link, :category1, :category2, :category3

  has_attached_file :artwork, styles: { thumb: "80x80", medium: "180x180" }

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

#  validates_presence_of :name, :author, :description, :keywords, :category1
	validates_presence_of :name, :author
	validates_uniqueness_of :name

	after_update :flush_name_cache

	def flush_name_cache
		Rails.cache.delete([:category, id, :name]) if name_changed?
	end

	def since_last_episode
		if episode = self.episodes.published.recent.first
			distance_of_time_in_words(DateTime.now, episode.published_at) + " ago"
		end
	end

	def until_next_episode
		if episode = self.episodes.scheduled.first
			episode.published_at.strftime("%d.%m.%y %H:%M")
		end
	end

	CATEGORIES = [
		"Arts: Design",
		"Arts: Fashion & Beauty",
		"Arts: Food",
		"Arts: Literature",
		"Arts: Performing Arts",
		"Arts: Visual Arts",
		"Business: Business New",
		"Business: Careers",
		"Business: Investing",
		"Business: Management & Marketing",
		"Business: Shopping",
		"Comedy",
		"Education: Education",
		"Education: Education Technology",
		"Education: Higher Education",
		"Education: K-12",
		"Education: Language Courses",
		"Education: Training",
		"Games & Hobbies: Automotive",
		"Games & Hobbies: Aviation",
		"Games & Hobbies: Hobbies",
		"Games & Hobbies: Other Games",
		"Games & Hobbies: Video Games",
		"Government & Organizations: Local",
		"Government & Organizations: National",
		"Government & Organizations: Non-Profit",
		"Government & Organizations: Regional",
		"Health: Alternative Health",
		"Health: Fitness & Nutrition",
		"Health: Self-Help",
		"Health: Sexuality",
		"Kids & Family",
		"Music",
		"News & Politics",
		"Religion & Spirituality: Buddhism",
		"Religion & Spirituality: Christianity",
		"Religion & Spirituality: Hinduism",
		"Religion & Spirituality: Islam",
		"Religion & Spirituality: Judaism",
		"Religion & Spirituality: Other",
		"Religion & Spirituality: Spirituality",
		"Science & Medicine: Medicine",
		"Science & Medicine: Natural Sciences",
		"Science & Medicine: Social Sciences",
		"Society & Culture: History",
		"Society & Culture: Personal Journals",
		"Society & Culture: Philosophy",
		"Society & Culture: Places & Travel",
		"Sports & Recreation: Amateur",
		"Sports & Recreation: College & High School",
		"Sports & Recreation: Outdoor",
		"Sports & Recreation: Professional",
		"Technology: Gadgets",
		"Technology: Tech News",
		"Technology: Podcasting",
		"Technology: Software How-To",
		"TV & Film"
	]
end
