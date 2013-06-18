class EpisodePresenter < BasePresenter
  presents :episode

  def full_title
    "#{episode.podcast.name} #{num}: #{episode.title}"
  end

  def duration
    unless episode.playtime.blank?
      hours_string = ""
      hours_string = "#{h.pluralize(episode.hours, 'Stunde', 'Stunden')} " if episode.hours > 0
      minutes_string = h.pluralize(episode.minutes, 'Minute', 'Minuten')
    
      " &#8226; #{hours_string} #{minutes_string}".html_safe
    end
  end

  def num
    episode.number.to_s.rjust(3, '0')
  end

  def podlove_chapters
    if episode.chapters.size > 0
      chapters = []
      episode.chapters.order("timestamp asc").each do |chapter|
        chapters << { :start => chapter.pretty_time, :title => chapter.title }
      end
      chapters
    else
      ""
    end
  end

  def description
    markdown(episode.description)
  end

  def clean_description
    episode.description.gsub(/\[([^\]]+)\]\(([^)]+)\)/, '\1').gsub(/[_*]/, '')
  end

  def truncated_clean_description
    h.truncate(clean_description, length: 150)
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
    faulty_files = []
    episode.audio_files.each do |file|
      if file.size.nil?
        faulty_files << file.media_type
      end
    end
    faulty_files
  end
end