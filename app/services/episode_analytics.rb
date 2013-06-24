class EpisodeAnalytics
  
  def self.update
    Episode.all.each do |episode|
      hits = calculate_hits(episode)
      downloaded = calculate_downloaded(episode)
      downloads = calculate_downloads(episode)
      episode.update_attributes(hits: hits, downloaded: downloaded, downloads: downloads)
    end
  end

  def self.graph(episode)
    (4.weeks.ago.to_date..Date.today).map do |date|
      {
        date: date,
        mp4: downloads_on(episode, date, "mp4"),
        mp3: downloads_on(episode, date, "mp3"),
        ogg: downloads_on(episode, date, "ogg"),
        opus: downloads_on(episode, date, "opus")
      }
    end
  end

  def self.files(episode)
    episode.audio_files.order('media_type').map(&:media_type)
  end

private

  def self.calculate_hits(episode)
    episode.audio_files.sum(&:total_hits)
  end
  
  def self.calculate_downloaded(episode)
    episode.audio_files.sum(&:total_download_size)
  end

  def self.calculate_downloads(episode)
    episode.audio_files.sum(&:total_download_count)
  end

  def self.downloads_on(episode, date, type)
    file = episode.audio_files.find_by_media_type(type)
    file.downloads_on(date) if file
  end

end