class Episode < ActiveRecord::Base
  extend FriendlyId
  friendly_id :number, use: :slugged

  belongs_to :podcast
  has_many :show_notes
  has_many :chapters
  has_many :introduced_titles
  has_many :audio_files

  attr_accessible :description, :playtime, :number, :podcast_id, :podcast, :title, :slug, :created_at, :draft
  attr_accessible :show_notes_attributes, :chapters_attributes, :explicit, :chapter_marks, :published_at
  attr_accessible :introduced_titles_attributes, :spotify_playlist, :chapter_file, :audio_files_attributes
  accepts_nested_attributes_for :show_notes, :chapters, :introduced_titles, :audio_files, allow_destroy: true

  after_create :set_slug
  before_save :ensure_published_at, unless: :draft?

  scope :published, lambda { where(draft: false).where('published_at <= ?', Time.now.utc) }
  scope :scheduled, lambda { where('published_at > ?', Time.now.utc).order('published_at asc') }
  scope :recent, order("published_at DESC")

  before_validation :custom_before_validation
  validates_presence_of :podcast, :number, :title
  validates_uniqueness_of :title, :number, scope: :podcast_id
  validates_presence_of :description, :unless => Proc.new { |episode| episode.draft.present? }
  validates :audio_files, length: { minimum: 1 }, :unless => Proc.new { |episode| episode.draft.present? }

  def full_title
    "#{self.podcast.name} #{num}: #{self.title}"
  end

  def num
    self.number.to_s.rjust(3, '0')
  end

  def chapter_marks
    chapters.order("timestamp asc").map { |c| c.to_s }.join("\n")
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
          parse_chapter(line, count)
        end
      end
    end
    delete_remaining_chapters(count)
    self.save
  end

  def chapter_file=(file)
    type = file.content_type

    if type.include? "text"
      count = parse_text_chapter_file(file)
    elsif type.include? "json"
      count = parse_json_chapter_file(file)
    end

    delete_remaining_chapters(count)
    self.save
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

  def file_url(type)
    file = audio_files.find_by_media_type(type)
    if file
      file.url
    else
      file
    end
  end

  def seconds
    playtime % 60
  end

  def minutes
    (playtime / 60) % 60
  end

  def hours
    playtime / (60 * 60)
  end

  def total_downloads
    audio_files.sum(&:total_download_count)
  end

private

  def parse_text_chapter_file(file)
    count = 0
    File.open(file.tempfile, 'r').each_line do |line, index|
      count += 1
      parse_chapter(line, count)
    end
    count
  end

  def parse_json_chapter_file(file)
    count = 0
    json = JSON.parse File.read(file.tempfile)
    self.playtime = json['length'].to_i
    json['chapters'].each do |chapter|
      count += 1
      create_or_update_chapter(count, chapter['start'], chapter['title'])
    end
    count
  end

  def parse_chapter(line, count)
    time = line.scan(/\d{0,3}[:.]?\d{1,2}[:.]\d{1,2}/)[0].gsub '.', ':'
    time = time.prepend("0:") if time.count(':') == 1
    title = line.scan(/\s(.+)/)[0][0].gsub(/<.+>/, "").chomp
    create_or_update_chapter(count, time, title)
  end

  def create_or_update_chapter(count, time, title)
    if count <= self.chapters.count
      chapter = self.chapters[count-1]
      chapter.update_attributes(pretty_time: time, title: title)
    else
      chapter = Chapter.create!(pretty_time: time, title: title, episode_id: self.id)
      self.chapters << chapter
    end
  end

  def delete_remaining_chapters(count)
    for n in count...self.chapters.count do
      self.chapters[n].delete
    end
  end

  def set_slug
    update_attribute :slug, number
  end

  def custom_before_validation
    if @virtual_errors
      @virtual_errors.each do |k,v|
        v.each { |e| errors[k] << e }
      end
    end
  end

  def ensure_published_at
    self.published_at ||= Time.zone.now
  end
end
