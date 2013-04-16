class Podcast < ActiveRecord::Base
	has_many :episodes, dependent: :destroy
  attr_accessible :description, :name, :slug, :artwork, :author, :keywords, :explicit, :itunes_link, :category1, :category2, :category3

  has_attached_file :artwork

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

#  validates_presence_of :name, :author, :description, :keywords, :category1
	validates_presence_of :name, :author
	validates_uniqueness_of :name

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
