class Podcast < ActiveRecord::Base
	has_many :episodes, dependent: :destroy
  has_many :subscribers

  attr_accessible :description, :name, :slug, :artwork, :author, :keywords, :explicit, :itunes_link, :category1, :category2, :category3

  has_attached_file :artwork, styles: { thumb: "80x80", medium: "180x180" }

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

	validates_presence_of :name, :author
	validates_uniqueness_of :name

	after_update :flush_name_cache

	def flush_name_cache
		Rails.cache.delete([:category, id, :name]) if name_changed?
	end

	def latest_episode
		self.episodes.published.recent.first
	end

  def last_episode
    self.episodes.order("number DESC").first
  end

end
