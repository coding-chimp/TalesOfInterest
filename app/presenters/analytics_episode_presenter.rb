class AnalyticsEpisodePresenter < BasePresenter
  presents :episode
  delegate :total_hits, :total_downloads, to: :episode

  def hits_percentage
    h.number_to_percentage(episode.total_hits.to_f / max_hits * 100)
  end

  def total_downloaded
  #  "#{episode.total_downloaded / 1048576} MB"
    h.number_to_human_size(episode.total_downloaded)
  end

  def downloaded_percentage
    h.number_to_percentage(episode.total_downloaded.to_f / max_downloaded * 100)
  end

  def downloads_percentage
    h.number_to_percentage(episode.total_downloads.to_f / max_downloads * 100)
  end

private

  def max_hits
    Episode.all.max_by(&:total_hits).total_hits
  end

  def max_downloaded
    Episode.all.max_by(&:total_downloaded).total_downloaded
  end

  def max_downloads
    Episode.all.max_by(&:total_downloads).total_downloads
  end
end