class Chapter < ActiveRecord::Base
	belongs_to :episode

  attr_accessible :episode_id, :timestamp, :title, :pretty_time

  def pretty_time
  	Time.at(timestamp).gmtime.strftime('%H:%M:%S') if timestamp 
  end

  def pretty_time=(time)
  	self.timestamp = Time.parse(time).seconds_since_midnight.to_i
  end

  def as_json(options={})
    { start: pretty_time, title: title }
  end

  def to_s
    "#{pretty_time} #{title}"
  end
end
