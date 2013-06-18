class EpisodePresenter < BasePresenter
  presents :episode

  ## Views

  def duration
    unless episode.playtime.blank?
      hours_string = ""
      hours_string = "#{h.pluralize(hours, 'Stunde', 'Stunden')} " if hours > 0
      minutes_string = h.pluralize(minutes, 'Minute', 'Minuten')
    
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
    error = false
    episode.audio_files.each do |file|
      if file.size.nil?
        error = true
        break
      end
    end
    "error" if error
  end

  def connection_error_message
    if connection_error.present?
      faulty_files = []
      episode.audio_files.each do |file|
        if file.size.nil?
          faulty_files << file.media_type
        end
      end
      "<br /><span class=\"text-error\">Couldn't connect to <b>#{faulty_files.join(", ")}</b> #{pluralize_without_count(faulty_files.size, "file")}. Please check the file #{pluralize_without_count(faulty_files.size, "url")}.</span>"
    end
  end

  def publish_date
    string = ""
    if episode.draft
      string << h.content_tag(:b, "Draft")
    else
      if episode.published_at > DateTime.now
        string << h.content_tag(:b, "Scheduled")
        string << h.tag("br")
      end 
      string << episode.published_at.strftime("%d.%m.%y %H:%M")
    end
    string
  end

  ## Feed

  def full_title
    "#{episode.podcast.name} #{num}: #{episode.title}"
  end

  def pluralize_without_count(count, noun, text = nil)
    if count != 0
      count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
    end
  end

  def feed_duration
    unless episode.playtime.blank?
      if hours > 0
        format("%d:%02d:%02d", hours, minutes, seconds)
      else
        format("%d:%02d", minutes, seconds) 
      end
    else
      ""
    end
  end

  def feed_file
    if file = episode.audio_files.find_by_media_type("mp4")
    elsif file = episode.audio_files.find_by_media_type("mp3")
    end
    file      
  end

  def feed_file_type
    if feed_file.media_type == "mp4"
      'audio/x-m4a'
    elsif feed_file.media_type = "mp3"
      'audio/mpeg'
    end
  end

  def content
    content = episode.description
    if episode.introduced_titles.size > 0
      content << "</p>" + stringify_introduced_titles.html_safe
    end
    if episode.show_notes.size > 0
      content << "</p>" + stringify_show_notes.html_safe
    end
    content
  end

private

  def seconds
    episode.playtime % 60
  end

  def minutes
    (episode.playtime / 60) % 60
  end

  def hours
    episode.playtime / (60 * 60)
  end

  def pagination_link(episode_num, klass)
    if ep = Episode.published.where(podcast_id: episode.podcast.id, number: episode_num).first
      h.content_tag :li, class: klass do
        h.link_to "#{klass.titleize} Episode", h.episode_path(episode.podcast, ep)
      end
    end
  end

  def stringify_introduced_titles
    string = "<p>Vorgestellte Titel:</p><ul>"
    string << stringify(episode.introduced_titles)
    string << "</ul><p>"
  end

  def stringify_show_notes
    string = "<p>Show Notes:</p><ul>"
    string << stringify(episode.show_notes.order('position'))
    string << "</ul><p>"
  end

  def stringify(array)
    string = ""
    array.each do |object|
      string << "<li><a href=\"#{object.url}\">#{object.name}</a></li>"
    end
    string
  end
end