class Traffic < ActiveRecord::Base
  attr_accessible :date, :people, :views

  validates_presence_of :date, :people, :views
  validates_uniqueness_of :date

  def as_json
    { date: date, people: people, views: views }
  end

  def self.update_today
    today = Traffic.find_or_create_by_date(Date.today)
    yesterday = Traffic.find_or_create_by_date(Date.today-1)
    json = fetch_gauges
    json['gauges'].each do |gauge|
      next unless gauge['title'] == Settings.first.site_name
      today.update_attributes(views: gauge['today']['views'], people: gauge['today']['people'])
      yesterday.update_attributes(views: gauge['yesterday']['views'], people: gauge['yesterday']['people'])
    end
  end

  def self.update_history(uri = nil)
    uri ||= "https://secure.gaug.es/gauges/#{Settings.first.gauges}/traffic"
    json = fetch_traffic(uri)
    process_data(json['traffic'])
    if older = json['urls']['older']
      update_history(older)
    end
  end

private

  def self.fetch_gauges
    JSON.parse(open("https://secure.gaug.es/gauges", 'X-Gauges-Token' => Settings.first.gauges_key).read)
  end

  def self.fetch_traffic(uri)
    JSON.parse(open(uri, 'X-Gauges-Token' => Settings.first.gauges_key).read)
  end

  def self.process_data(json)
    json.each do |entry|
      date = Date.parse(entry['date'])
      day = Traffic.find_or_create_by_date(date)
      day.update_attributes(views: entry['views'], people: entry['people']) 
    end
  end
end
