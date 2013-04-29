class Episode < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  belongs_to :podcast
  has_many :show_notes
  has_many :chapters
  has_many :introduced_titles

  attr_accessible :description, :file, :playtime, :number, :podcast_id, :podcast, :title, :slug, :created_at, :show_notes_attributes, :chapters_attributes, :file_size, :explicit, :chapter_marks, :published_at, :draft, :introduced_titles_attributes
  accepts_nested_attributes_for :show_notes, allow_destroy: true
  accepts_nested_attributes_for :chapters, allow_destroy: true
  accepts_nested_attributes_for :introduced_titles, allow_destroy: true

  extend FriendlyId
  friendly_id :number, use: :slugged

  after_create :set_slug
  before_save :fetch_file_size
  before_save :ensure_published_at, unless: :draft?

  scope :published, lambda { where(draft: false).where('published_at <= ?', Time.now.utc) }
  scope :unpublished, lambda { where(draft: true).where('published_at > ?', Time.now.utc) }
  scope :recent, order("published_at DESC")

  validates_presence_of :podcast, :number, :title
  validate :unique_title
  validate :unique_number
  validates_presence_of :description, :file, :playtime, 
                        :unless => Proc.new { |episode| episode.draft.present? }

  def unique_title
    resp = true
    podcast.episodes.each do |ep|
      unless ep == self
        if ep.title == title
          resp = false
        end
      end
    end
    unless resp == true
      errors.add(:title, 'already exists')
    end
  end

  def unique_number
    resp = true
    podcast.episodes.each do |ep|
      unless ep == self
        if ep.number == number
          resp = false
        end
      end
    end
    unless resp == true
      errors.add(:number, 'already exists')
    end
  end

  def podcast_name
    Rails.cache.fetch([:podcast, podcast_id, :name], expires_in: 15.minutes) do
      podcast.name
    end
  end

  def duration
    seconds = playtime % 60
    minutes = (playtime / 60) % 60
    hours = playtime / (60 * 60)

    if hours > 0
      "#{pluralize(hours, 'Stunde', 'Stunden')} #{pluralize(minutes, 'Minute', 'Minuten')}"
    else
      pluralize(minutes, 'Minute', 'Minuten')
    end
  end

  def feed_duration
    seconds = playtime % 60
    minutes = (playtime / 60) % 60
    hours = playtime / (60 * 60)

    if hours > 0
      format("%d:%02d:%02d", hours, minutes, seconds)
    else
      format("%d:%02d", minutes, seconds) 
    end
  end

  def num
    number.to_s.rjust(3, '0')
  end

  def chapter_marks
    chapter_marks = ""
    chapters.order("timestamp asc").each do |chapter|
      chapter_marks << "#{chapter.pretty_time} #{chapter.title}\n"
    end
    chapter_marks
  end

  def chapter_marks=(chapter_marks)
    count = 0
    chapter_marks.each_line do |line|
      unless line.empty?
        count += 1
        time = line.scan(/\d\d:\d\d:\d\d/)[0]
        title = line.scan(/\d (\D*)/)[0][0].chomp
        if count <= self.chapters.count
          c = self.chapters[count-1]
          c.update_attributes(:pretty_time => time, :title => title)
        else
          c = Chapter.create!(:pretty_time => time, :title => title, :episode_id => id)
          self.chapters << c
        end
      end
    end
    self.save
  end

  def podlove_chapters
    chapters = "[{'start':'00:00:00.000','title':'Intro','image':''}"
    self.chapters.order("timestamp asc")[1..-1].each do |chapter|
      chapters << "\n,{'start':'#{chapter.pretty_time}','title':'#{chapter.title}','image':''}"
    end
    chapters << "]"
  end

  def set_episode_number
    if podcast.episodes.size > 1
      podcast.episodes.order("number").last.number + 1
    else
      1
    end
  end

  def set_file_url
    podcast_name = podcast.name.downcase
    nr = set_episode_number.to_s.rjust(3, '0')
    "http://www.talesofinterest.de/podcasts/#{podcast_name}#{nr}.m4a"
  end

  def clean_description
    description.gsub(/\[([^\]]+)\]\(([^)]+)\)/, '\1').gsub(/[_*]/, '')
  end

  def content
    content = self.description
    if self.introduced_titles.size > 0
      content << "\n" + self.stringify_introduced_titles.html_safe
    end
    if self.show_notes.size > 0
      content << "\n" + self.stringify_show_notes.html_safe
    end
    content
  end

  def stringify_introduced_titles
    string = "<p>Vorgestellte Titel:</p>\n<ul>"
    introduced_titles.each do |title|
      string << "<li><a href='#{title.url}>#{title.name}</a></li>\n"
    end
    string << "</ul>"
  end

  def stringify_show_notes
    string = "<p>Show Notes:</p>\n<ul>"
    show_notes.each do |show_note|
      string << "<li><a href='#{show_note.url}>#{show_note.name}</a></li>\n"
    end
    string << "</ul>"
  end

  def type
    if file.include?("mp3")
      type = 'audio/mpeg'
    else
      type = 'audio/x-m4a'
    end
  end

  private

  def ensure_published_at
    self.published_at ||= Time.zone.now
  end

  def fetch_file_size
    url = URI.parse(self.file)
    response = Net::HTTP.start(url.host, url.port) do |http|
      http.request_head(url.path)
    end
    if response.code == "200"
      self.file_size = response["content-length"].to_i
    end
  end

  def set_slug
    update_attribute :slug, number
  end
end
