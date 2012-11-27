class Episode < ActiveRecord::Base
	belongs_to :podcast
  has_many :show_notes

  attr_accessible :description, :episode_url, :length, :number, :podcast_id, :podcast, :title, :slug, :created_at, :show_notes_attributes
  accepts_nested_attributes_for :show_notes, :allow_destroy => true

  extend FriendlyId
  friendly_id :number, use: :slugged
end
