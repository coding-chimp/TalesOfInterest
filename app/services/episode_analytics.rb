class EpisodeAnalytics
  
  def self.update
    Episode.all.each do |episode|
      hits = calculate_hits(episode)
      downloaded = calculate_downloaded(episode)
      downloads = calculate_downloads(episode)
      episode.update_attributes(hits: hits, downloaded: downloaded, downloads: downloads)
    end
  end

  def self.graph(episode, start, stop)
    mp4_downloads_by_day  = downloads_grouped_by_day(episode, "mp4", start, stop)
    mp3_downloads_by_day  = downloads_grouped_by_day(episode, "mp3", start, stop)
    ogg_downloads_by_day  = downloads_grouped_by_day(episode, "ogg", start, stop)
    opus_downloads_by_day = downloads_grouped_by_day(episode, "opus", start, stop)
    (start.to_date..stop.to_date).map do |date|
      {
        date: date,
        mp4:  mp4_downloads_by_day[date].try(:first).try(:downloads)  || 0,
        mp3:  mp3_downloads_by_day[date].try(:first).try(:downloads)  || 0,
        ogg:  ogg_downloads_by_day[date].try(:first).try(:downloads)  || 0,
        opus: opus_downloads_by_day[date].try(:first).try(:downloads) || 0
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

  def self.downloads_grouped_by_day(episode, type, start, stop)
    file = episode.audio_files.find_by_media_type(type)
    if file
      fetch_downloads(file, start, stop)
    else
      { date: Date.today }
    end
  end

  def self.fetch_downloads(file, start, stop)
    downloads = DownloadData.where(audio_file_id: file.id, date: start..stop)
    downloads = downloads.group("id, date(date)")
    downloads = downloads.select("date, round(sum(downloaded)/#{file.size.to_f},2) as downloads")
    downloads.group_by { |d| d.date }
  end
end