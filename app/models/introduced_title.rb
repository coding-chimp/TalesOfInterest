class IntroducedTitle < ActiveRecord::Base
  attr_accessible :episode_id, :name, :url
  belongs_to :episode
end
