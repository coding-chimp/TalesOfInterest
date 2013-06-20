class Subscriber < ActiveRecord::Base
  belongs_to :podcast

  attr_accessible :count, :date, :reader, :podcast_id, :podcast

  validates_presence_of :count, :date, :reader, :podcast_id

  def self.latest(podcast)
    subscribers = where(podcast_id: podcast.id, date: Date.today)
    if subscribers.count == 0
      subscribers = where(podcast_id: podcast.id, date: Date.today-1)
    end
    subscribers
  end

  def self.update
    Podcast.all.each do |podcast|
      readers = fetch_readers(podcast.name)
      readers.each do |reader|
        subscribers = podcast.subscribers.find_or_create_by_date_and_reader(Date.today, reader['name'])
        subscribers.update_attributes(count: reader['subscribers'], podcast: podcast)
      end
    end
  end

  def as_json
    { label: reader, value: count }
  end

private

  def self.fetch_readers(podcast)
    uri = URI.parse("http://api.feedpress.it/feeds/readers.json")
    params = { :key => Settings.first.uri_key, :token => Settings.first.uri_token, :feed => podcast.downcase }
    uri.query = URI.encode_www_form(params)
    JSON.parse(uri.open.read)['readers']
  end

end
