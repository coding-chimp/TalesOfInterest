class Podcast < ActiveRecord::Base
	has_many :episodes, dependent: :destroy
  attr_accessible :description, :name, :slug, :artwork, :author, :keywords, :explicit, :category_list, :itunes_link

  acts_as_taggable_on :categories

  has_attached_file :artwork

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

#  validates_presence_of :name, :author, :description, :keywords, :categories
	validates_presence_of :name, :author
	validates_uniqueness_of :name
end
