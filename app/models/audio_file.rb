class AudioFile < ActiveRecord::Base
  attr_accessible :size, :type, :url, :episode, :episode_id

  belongs_to :episode
end
