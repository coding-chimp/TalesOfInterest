class EpisodePresenter
  def initialize(episode, template)
    @episode = episode
    @template = template
  end

  def h
    @template
  end

  def duration
    playtime = @episode.playtime
    unless playtime.blank?
      minutes = (playtime / 60) % 60
      hours = playtime / (60 * 60)

      hours_string = ""
      hours_string = "#{h.pluralize(hours, 'Stunde', 'Stunden')} " if hours > 0
      minutes_string = h.pluralize(minutes, 'Minute', 'Minuten')
    
      " &#8226; #{hours_string} #{minutes_string}".html_safe
    end
  end

  def num
    @episode.number.to_s.rjust(3, '0')
  end

  def podlove_chapters
    if @episode.chapters.size > 0
      chapters = []
      @episode.chapters.order("timestamp asc").each do |chapter|
        chapters << { :start => chapter.pretty_time, :title => chapter.title }
      end
      chapters
    else
      ""
    end
  end

  def prev_link
    pagination_link(@episode.number-1, "previous")
  end

  def next_link
    pagination_link(@episode.number+1, "next")
  end

  private

  def pagination_link(episode_num, klass)
    if episode = Episode.published.where(podcast_id: @episode.podcast.id, number: episode_num).first
      h.content_tag :li, class: klass do
        h.link_to "#{klass.titleize} Episode", h.episode_path(@episode.podcast, episode)
      end
    end
  end
end