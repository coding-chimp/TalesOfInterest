class DownloadData < ActiveRecord::Base
  attr_accessible :audio_file_id, :date, :downloaded, :hits

  belongs_to :audio_file

  def self.update(date)
    json = fetch_downloads(date.to_s, date.to_s)
    process_data(json['table']['rows'], date)
  end

private

  def self.fetch_downloads(from, to)
    digest_auth = Net::HTTP::DigestAuth.new
    uri = build_uri(from, to)

    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    req = Net::HTTP::Get.new uri.request_uri
    req.add_field 'Accept', 'application/json'
    res = http.request req

    auth = digest_auth.auth_header uri, res['www-authenticate'], 'GET'
    req = Net::HTTP::Get.new uri.request_uri
    req.add_field 'Authorization', auth
    res = http.request req

    JSON.parse res.body
  end

  def self.build_uri(from, to)
    uri = URI.parse "https://api.qloudstat.com/v1/6782979/dl.talesofinterest.de/uri,referrer/hits,bandwidth_outbound/values.json?from=#{from}&to=#{to}"
    uri.user = Settings.first.qloudstat_api_key
    uri.password = Settings.first.qloudstat_api_secret
    uri
  end

  def self.process_data(rows, date)
    rows.each do |row|
      name = row['c'][0]['v'][1..-1]
      referrer = row['c'][1]['v']
      hits = row['c'][2]['v']
      downloaded = row['c'][3]['v']
      
      if valid_name?(name) && no_dev_referrer?(referrer)
        audio_file = find_audio_file(name)
        unless audio_file.nil?
          download_data = audio_file.download_datas.find_or_create_by_date(date)
          download_data.update_attributes(hits: hits, downloaded: downloaded)
        end
      end
    end
  end

  def self.find_audio_file(name)
    type = File.extname(name)
    podcast_name = File.basename(name, type).titleize
    episode_num = podcast_name[-3..-1].to_i
    podcast_name = podcast_name[0..-4]

    podcast = Podcast.find_by_name(podcast_name)
    unless podcast.nil?
      episode = podcast.episodes.find_by_number(episode_num)
      unless episode.nil?
        type = type[1..-1] == "m4a" ? "mp4" : type[1..-1]
        audio_file = episode.audio_files.find_by_media_type(type)
      end
    end
    audio_file || nil
  end

  def self.valid_name?(name)
    name = name =~ /.m4a|.mp3|.opus|.ogg/
    name.nil? ? false : true
  end

  def self.no_dev_referrer?(referrer)
    referrer = referrer =~ /.dev|localhost/
    referrer.nil? ? true : false
  end
end
