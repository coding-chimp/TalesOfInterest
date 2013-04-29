module DashboardHelper

  def subscribers(podcast)
    uri = URI.parse("http://api.uri.lv/feeds/subscribers.json")
    params = { :key => Settings.first.uri_key, :token => Settings.first.uri_token, :feed => podcast.downcase }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    if stats = JSON.parse(response.body)['stats']
      subscribers = stats.first['greader'] + stats.first['other'] + stats.first['direct']
    else
      "ERROR"
    end
  end
end
