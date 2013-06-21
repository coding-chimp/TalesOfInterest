class PodcastPresenter < BasePresenter
  presents :podcast
  delegate :name, to: :podcast

  def linked_name
    h.content_tag :h2, h.link_to(podcast.name, h.podcast_path(podcast))
  end

  def description
    h.content_tag :p, podcast.description
  end

  def episodes_count
    podcast.episodes.count
  end

  def since_color_code
    if episode = podcast.latest_episode
      distance = Date.today - episode.published_at.to_date
      if distance <= 14
        "ok"
      elsif distance > 14 && distance <= 28
        "alert"
      else
        "warning"
      end 
    end
  end

  def since_last_episode
    if episode = podcast.latest_episode
      h.distance_of_time_in_words(DateTime.now, episode.published_at) + " ago"
    else
      '&nbsp'
    end
  end

  def until_next_episode
    if episode = podcast.episodes.scheduled.first
      episode.published_at.strftime("%d.%m.%y %H:%M")
    else
      '&nbsp'
    end
  end

  def top_episode
    podcast.episodes.max_by { |e| e.total_downloads }
  end

  def top_episode_title
    "##{top_episode.num} #{top_episode.title}"
  end

  def top_episode_downloads
    top_episode.total_downloads
  end

  def artwork_thumb(size)
    if podcast.artwork?
      h.content_tag :div, class: "thumbnail" do
        h.link_to h.image_tag(podcast.artwork.url(size)), podcast
      end
    end
  end

  def artwork(size)
    h.image_tag podcast.artwork.url(size) if podcast.artwork?
  end

  def subscribers
    Subscriber.latest(podcast).sum('count')
  end

  def subscribers_chart_data
    Subscriber.latest(podcast).as_json
  end

  ## Feed

  def uri
    h.podcast_url(podcast)
  end

  def pubDate
    episodes_count > 0 ? podcast.episodes.maximum('published_at').to_s(:rfc822) : podcast.created_at.to_s(:rfc822)
  end

  def explicit
    podcast.explicit? ? 'yes' : 'clean'
  end

  def feed_artwork
    h.root_url + podcast.artwork.url(:original, false)[1..-1]
  end

end