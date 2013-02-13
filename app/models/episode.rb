class Episode < ActiveRecord::Base
  belongs_to :podcast
  has_many :show_notes
  has_many :chapters

  attr_accessible :description, :file, :playtime, :number, :podcast_id, :podcast, :title, :slug, :created_at, :show_notes_attributes, :chapters_attributes, :file_size, :explicit
  accepts_nested_attributes_for :show_notes, :allow_destroy => true
  accepts_nested_attributes_for :chapters, :allow_destroy => true

  extend FriendlyId
  friendly_id :number, use: :slugged

  after_create :set_slug

  def num
    number.to_s.rjust(3, '0')
  end 

  def set_episode_number
    if number == nil
      if podcast.episodes.size > 1
        podcast.episodes.order("number").last.number + 1
      else
        1
      end
    end
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
