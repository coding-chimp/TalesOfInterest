class Episode < ActiveRecord::Base
  belongs_to :podcast
  has_many :show_notes
  has_many :chapters

  attr_accessible :description, :file, :playtime, :number, :podcast_id, :podcast, :title, :slug, :created_at, :show_notes_attributes, :chapters_attributes, :file_size, :explicit, :chapter_marks
  accepts_nested_attributes_for :show_notes, :allow_destroy => true
  accepts_nested_attributes_for :chapters, :allow_destroy => true

  extend FriendlyId
  friendly_id :number, use: :slugged

  after_create :set_slug

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

  def stringify_show_notes
    string = "<p>Links f&uuml;r diese Episode:</p><ul>
"
    show_notes.each do |show_note|
      string << "<li><a href='#{show_note.url}>#{show_note.name}</a></li>
"
    end
    string << "</ul>"
  end

  private

  def set_slug
    update_attribute :slug, number
  end
end
