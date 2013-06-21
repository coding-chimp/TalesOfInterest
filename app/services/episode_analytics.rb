class EpisodeAnalytics
  
  def self.update
    Episode.all.each do |episode|
      hits = calculate_hits(episode)
      downloaded = calculate_downloaded(episode)
      downloads = calculate_downloads(episode)
      episode.update_attributes(hits: hits, downloaded: downloaded, downloads: downloads)
    end
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

end