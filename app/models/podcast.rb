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

	def since_color_code
		if episode = self.episodes.published.recent.first
			distance = Date.today - episode.published_at.to_date
			if distance <= 14
				"ok"
			elsif distance > 14 && distance <= 28
				"alert"
			else
				"warning"
			end 
		end
	end

	def since_last_episode
		if episode = self.episodes.published.recent.first
			distance_of_time_in_words(DateTime.now, episode.published_at) + " ago"
		else
			'&nbsp'
		end
	end

	def until_next_episode
		if episode = self.episodes.scheduled.first
			episode.published_at.strftime("%d.%m.%y %H:%M")
		else
			'&nbsp'
		end
	end

end
