class Page < ActiveRecord::Base
  attr_accessible :content, :slug, :titel

  extend FriendlyId
  friendly_id :titel, use: [:slugged, :history]

  validates_presence_of :titel, :content
  validates_uniqueness_of :titel
end
