class ShowNote < ActiveRecord::Base
	belongs_to :episode
  attr_accessible :episode_id, :name, :url, :episode
  acts_as_list
end
