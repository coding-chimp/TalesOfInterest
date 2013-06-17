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
    if prev = Episode.published.where(podcast_id: @episode.podcast.id, number: @episode.number-1).first
      h.content_tag :li, class: "previous" do
        h.link_to "Previous Episode", h.episode_path(@episode.podcast, prev)
      end
    end
  end

  def next_link
    if next_ep = Episode.published.where(podcast_id: @episode.podcast.id, number: @episode.number+1).first
      h.content_tag :li, class: "next" do
        h.link_to "Next Episode", h.episode_path(@episode.podcast, next_ep)
      end
    end
  end
end