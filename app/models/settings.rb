class Settings < ActiveRecord::Base
  attr_accessible :favicon, :feed_author, :feed_email, :feed_language, :flattr_code, :ga_code, :posts_per_page, :site_name, :uri_key, :uri_token, :gauges, :gauges_key

  has_attached_file :favicon

  validates_presence_of :site_name, :posts_per_page, :feed_email, :feed_language
  
end
