class Podcast < ActiveRecord::Base
	has_many :episodes
  attr_accessible :description, :name, :slug

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
end
