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
    Episode.where(podcast_id: podcast.id).count
  end

  def since_last_episode
    if episode = podcast.latest_episode
      content = h.distance_of_time_in_words(DateTime.now, episode.published_at) + " ago"
    else
      content = '&nbsp'
    end

    h.content_tag :td, h.raw(content), class: since_color_code(episode)
  end

  def since_color_code(episode)
    if episode
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

  def until_next_episode
    if episode = podcast.episodes.scheduled.first
      episode.published_at.strftime("%d.%m.%y %H:%M")
    else
      '&nbsp'
    end
  end

  def top_episode
    episode = podcast.episodes.order('downloads DESC').first

    h.content_tag :a, "##{episode.num} #{episode.title}", href: "#", data: { tooltip: "" }, title: "#{episode.downloads} Downloads", class: 'has-tip tip-top'
  end

  def artwork_thumb(size)
    if podcast.artwork?
      h.content_tag :div, class: "th radius" do
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

  def bookmarklet_link
    "javascript:function toi1(){var d=document,z=d.createElement('scr'+'ipt'),b=d.body,l=d.location,t=d.title;try{if(!b) throw(0);z.setAttribute('src','#{h.root_url}show_notes/#{podcast.name}.js?u='+encodeURIComponent(l.href)+'&t='+encodeURIComponent(t));b.appendChild(z);}catch(e){alert('Please wait until the page has loaded.');}}toi1();void(0)"
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