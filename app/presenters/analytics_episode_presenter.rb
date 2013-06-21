class AnalyticsEpisodePresenter < BasePresenter
  presents :episode
  delegate :hits, :downloads, to: :episode

  def hits_percentage
    h.number_to_percentage(episode.hits.to_f / max_hits * 100)
  end

  def downloaded
    h.number_to_human_size(episode.downloaded)
  end

  def downloaded_percentage
    h.number_to_percentage(episode.downloaded.to_f / max_downloaded * 100)
  end

  def downloads_percentage
    h.number_to_percentage(episode.downloads.to_f / max_downloads * 100)
  end

private

  def max_hits
    Episode.maximum(:hits)
  end

  def max_downloaded
    Episode.maximum(:downloaded)
  end

  def max_downloads
    Episode.maximum(:downloads)
  end
end