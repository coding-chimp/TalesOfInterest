class EpisodesAnalyticsDatatable
  delegate :params, :h, :link_to, :number_to_human_size, :content_tag, :number_to_percentage, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Episode.count,
      iTotalDisplayRecords: episodes.total_count,
      aaData: data
    }
  end

private

  def data
    episodes.map do |episode|
      [
        full_title(episode),
        progress_bar(episode, :hits),
        progress_bar(episode, :downloaded),
        progress_bar(episode, :downloads),
        episode.title
      ]
    end
  end

  def episodes
    @episodes ||= fetch_episodes
  end

  def fetch_episodes
    episodes = Episode.includes(:podcast).order("#{sort_column} #{sort_direction}")
    episodes = episodes.page(page).per(per_page)
    if params[:sSearch].present?
      episodes = episodes.where("LOWER(title) like :search or CAST(number AS TEXT) like :search or LOWER(podcasts.name) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    episodes
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[number hits downloaded downloads]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def full_title(episode)
    "##{episode.num} #{episode.title} <span class='muted'>#{episode.podcast.name}</span>"
  end

  def progress_bar(episode, attribute)
    percentage = self.send("#{attribute}_percentage", episode)
    
    content_tag(:div, class: "progress radius"){
      content_tag(:span, self.send(attribute, episode), class: "meter", style: "width: #{percentage}")
    }
  end

  def hits(episode)
    episode.hits
  end

  def hits_percentage(episode)
    number_to_percentage(episode.hits.to_f / max_hits * 100)
  end

  def max_hits
    Episode.maximum(:hits)
  end

  def downloaded(episode)
    number_to_human_size(episode.downloaded)
  end

  def downloaded_percentage(episode)
    number_to_percentage(episode.downloaded.to_f / max_downloaded * 100)
  end

  def max_downloaded
    Episode.maximum(:downloaded)
  end

  def downloads(episode)
    episode.downloads
  end

  def downloads_percentage(episode)
    number_to_percentage(episode.downloads.to_f / max_downloads * 100)
  end

  def max_downloads
    Episode.maximum(:downloads)
  end
end