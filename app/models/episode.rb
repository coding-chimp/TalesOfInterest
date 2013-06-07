class Episode < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  belongs_to :podcast
  has_many :show_notes
  has_many :chapters
  has_many :introduced_titles
  has_many :audio_files

  attr_accessible :description, :file, :playtime, :number, :podcast_id, :podcast, :title, :slug, :created_at
  attr_accessible :show_notes_attributes, :chapters_attributes, :file_size, :explicit, :chapter_marks
  attr_accessible :published_at, :draft, :introduced_titles_attributes, :spotify_playlist
  attr_accessible :audio_files_attributes
  accepts_nested_attributes_for :show_notes, allow_destroy: true
  accepts_nested_attributes_for :chapters, allow_destroy: true
  accepts_nested_attributes_for :introduced_titles, allow_destroy: true
  accepts_nested_attributes_for :audio_files, allow_destroy: true

  extend FriendlyId
  friendly_id :number, use: :slugged

  after_create :set_slug
  before_save :ensure_published_at, unless: :draft?
  before_validation :custom_before_validation

  scope :published, lambda { where(draft: false).where('published_at <= ?', Time.now.utc) }
  scope :scheduled, lambda { where('published_at > ?', Time.now.utc).order('published_at asc') }
  scope :recent, order("published_at DESC")

  validates_presence_of :podcast, :number, :title
  validate :unique_title
  validate :unique_number
  validates_presence_of :description, :unless => Proc.new { |episode| episode.draft.present? }
  validates :audio_files, length: { minimum: 1 }, :unless => Proc.new { |episode| episode.draft.present? }

  def unique_title
    podcast.episodes.each do |ep|
      unless ep == self
        if ep.title == title
          errors.add(:title, 'already exists')
          break
        end
      end
    end
  end

  def unique_number
    podcast.episodes.each do |ep|
      unless ep == self
        if ep.number == number
          errors.add(:number, 'already exists')
          break
        end
      end
    end
  end

  def custom_before_validation
    if @virtual_errors
      @virtual_errors.each do |k,v|
        v.each { |e| errors[k] << e }
      end
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
    if playtime.present?
      seconds = playtime % 60
      minutes = (playtime / 60) % 60
      hours = playtime / (60 * 60)

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
    if file = audio_files.find_by_media_type("mp4")
    elsif file = audio_files.find_by_media_type("mp3")
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
        unless line =~ /^\d{0,3}[:.]?\d{1,2}[:.]\d{1,2}.?\d{0,3}\s.+$/
          @virtual_errors = { chapter_marks: ["not properly formatted: #{line}"] }
          break
        else
          count += 1
          time = line.scan(/\d{0,3}[:.]?\d{1,2}[:.]\d{1,2}/)[0].gsub '.', ':'
          if time.count(':') == 1
            time = time.prepend("0:")
          end
          title = line.scan(/\s(.+)/)[0][0].chomp
          if count <= self.chapters.count
            c = self.chapters[count-1]
            c.update_attributes(:pretty_time => time, :title => title)
          else
            c = Chapter.create!(:pretty_time => time, :title => title, :episode_id => id)
            self.chapters << c
          end
        end
      end
    end
    self.save
  end

  def podlove_chapters
    if self.chapters.size > 0
      chapters = []
      self.chapters.order("timestamp asc").each do |chapter|
        chapters << { :start => chapter.pretty_time, :title => chapter.title }
      end
      chapters
    else
      ""
    end
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
    "http://dl.talesofinterest.de/#{podcast_name}#{nr}.m4a"
  end

  def clean_description
    description.gsub(/\[([^\]]+)\]\(([^)]+)\)/, '\1').gsub(/[_*]/, '')
  end

  def content
    content = self.description
    if self.introduced_titles.size > 0
      content << "</p>" + self.stringify_introduced_titles.html_safe
    end
    if self.show_notes.size > 0
      content << "</p>" + self.stringify_show_notes.html_safe
    end
    content
  end

  def stringify_introduced_titles
    string = "<p>Vorgestellte Titel:</p><ul>"
    introduced_titles.each do |title|
      string << "<li><a href=\"#{title.url}\">#{title.name}</a></li>"
    end
    string << "</ul><p>"
  end

  def stringify_show_notes
    string = "<p>Show Notes:</p><ul>"
    show_notes.each do |show_note|
      string << "<li><a href=\"#{show_note.url}\">#{show_note.name}</a></li>"
    end
    string << "</ul><p>"
  end

  def connection_error?
    error = false
    audio_files.each do |file|
      if file.size.nil?
        error = true
        break
      end
    end
    error
  end

  def connection_error_message
    faulty_files = []
    audio_files.each do |file|
      if file.size.nil?
        faulty_files << file.media_type
      end
    end
    "Couldn't connect to <b>#{faulty_files.join(", ")}</b> #{pluralize_without_count(faulty_files.size, "file")}. Please check the file #{pluralize_without_count(faulty_files.size, "url")}."
  end

  def file_url(type)
    file = audio_files.find_by_media_type(type)
    if file
      file.url
    else
      file
    end
  end

  private

  def pluralize_without_count(count, noun, text = nil)
    if count != 0
      count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
    end
  end

  def ensure_published_at
    self.published_at ||= Time.zone.now
  end

  def set_slug
    update_attribute :slug, number
  end
end
