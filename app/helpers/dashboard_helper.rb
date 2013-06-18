module DashboardHelper

  def subscribers(podcast)
    uri = URI.parse("http://api.uri.lv/feeds/subscribers.json")
    params = { :key => Settings.first.uri_key, :token => Settings.first.uri_token, :feed => podcast.downcase }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    if stats = JSON.parse(response.body)['stats']
      stats.first['greader']
    else
      "ERROR"
    end
  end

  def subscribers_chart_data(podcast)
    uri = URI.parse("http://api.uri.lv/feeds/readers.json")
    params = { :key => Settings.first.uri_key, :token => Settings.first.uri_token, :feed => podcast.downcase }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    if readers = JSON.parse(response.body)['readers']
      stats = []
      readers.each do |reader|
        stats << { label: reader['name'], value: reader['subscribers'] }
      end
      stats
    end
  end

  def traffic_data
    Traffic.order("date DESC").limit(31).as_json
  end

end
