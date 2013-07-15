class EpisodePresenter < BasePresenter
  presents :episode
  delegate :title, :num, :full_title, :file_url, to: :episode

  def linked_podcast_name
    podcast_presenter.send(:linked_name)
  end

  def podcast_description
    podcast_presenter.send(:description)
  end

  def linked_title(controller)
    if controller == "episodes"
      title = episode.full_title
    elsif controller == "podcasts"
      title = "##{episode.num}: #{episode.title}"
    end
    h.link_to title, h.episode_path(episode.podcast, episode)
  end

  def published_at
    episode.published_at.strftime("%d. %B %Y")
  end

  def uri
    h.episode_url(episode.podcast, episode)
  end

  def artwork
    podcast_presenter.send(:artwork_thumb, :medium)
  end

  def duration
    if episode.playtime.present?
      if episode.hours > 0
        format("%d:%02d:%02d", episode.hours, episode.minutes, episode.seconds)
      else
        format("%d:%02d", episode.minutes, episode.seconds) 
      end
    end
  end

  def duration_in_words
    unless episode.playtime.blank?    
      " <small>&#8226;</small> #{h.pluralize(episode.hours, 'Stunde', 'Stunden') if episode.hours > 0} #{h.pluralize(episode.minutes, 'Minute', 'Minuten')}".html_safe
    end
  end

  def chapters
    episode.chapters.order("timestamp asc").as_json
  end

  def description
    markdown(episode.description)
  end

  def clean_description
    episode.description.gsub(/\[([^\]]+)\]\(([^)]+)\)/, '\1').gsub(/[_*]/, '')
  end

  def truncated_clean_description
    h.truncate(clean_description, length: 250)
  end

  def prev_link
    pagination_link(episode.number-1, "previous")
  end

  def next_link
    pagination_link(episode.number+1, "next")
  end

  def connection_error
    "error" if connection_error_message.present?
  end

  def connection_error_message
    "<br /><span class=\"text-error\">Couldn't connect to <b>#{faulty_files.join(", ")}</b> #{pluralize_without_count(faulty_files.size, "file")}. Please check the file #{pluralize_without_count(faulty_files.size, "url")}.</span>" unless faulty_files.empty?
  end

  def publish_date
    if episode.draft
      h.content_tag(:b, "Draft")
    else
      publish_date_helper
    end
  end

private

  def podcast_presenter
    PodcastPresenter.new(episode.podcast, h)
  end

  def pagination_link(episode_num, klass)
    if ep = Episode.published.where(podcast_id: episode.podcast.id, number: episode_num).first
      h.content_tag :li, class: klass do
        h.link_to "#{klass.titleize} Episode", h.episode_path(episode.podcast, ep)
      end
    end
  end

  def publish_date_helper
    string = ""
    if episode.published_at > DateTime.now
      string << h.content_tag(:b, "Scheduled")
      string << h.tag("br")
    end 
    string << episode.published_at.strftime("%d.%m.%y %H:%M")
  end

  def faulty_files
    episode.audio_files.where(size: nil).pluck(:media_type)
  end
end