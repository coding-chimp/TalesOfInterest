class Podcast < ActiveRecord::Base
	has_many :episodes, :dependent => :destroy
  attr_accessible :description, :name, :slug, :artwork

  has_attached_file :artwork

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
end
