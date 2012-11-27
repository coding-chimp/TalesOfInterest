class Page < ActiveRecord::Base
  attr_accessible :content, :slug, :titel

  extend FriendlyId
  friendly_id :titel, use: [:slugged, :history]
end
