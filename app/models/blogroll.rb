class Blogroll < ActiveRecord::Base
  attr_accessible :description, :name, :url

  validates :name, :url, :description, presence: true, uniqueness: true
  validates :url, format: URI::regexp(%w(http https))
end
