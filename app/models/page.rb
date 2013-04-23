class Page < ActiveRecord::Base
  attr_accessible :content, :slug, :title, :footer

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  validates_presence_of :title, :content
  validates_uniqueness_of :title
end
