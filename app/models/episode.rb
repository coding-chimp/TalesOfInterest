class Episode < ActiveRecord::Base
  belongs_to :podcast
  has_many :show_notes
  has_many :chapters

  attr_accessible :description, :file, :playtime, :number, :podcast_id, :podcast, :title, :slug, :created_at, :show_notes_attributes, :chapters_attributes
  accepts_nested_attributes_for :show_notes, :allow_destroy => true
  accepts_nested_attributes_for :chapters, :allow_destroy => true

  has_attached_file :file, :default_url => :set_default_url

  extend FriendlyId
  friendly_id :number, use: :slugged

  def num
    if number < 10
      return "00#{number}"
    elsif number < 100
      return "0#{number}"
    else
      return number
    end      
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

  private

  def set_default_url
    "http://www.talesofinterest.de/podcasts/#{podcast.name.underscore}#{num}.m4a"
  end
end
