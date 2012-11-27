class ShowNote < ActiveRecord::Base
	belongs_to :episode
  attr_accessible :description, :episode_id, :name, :url
end
