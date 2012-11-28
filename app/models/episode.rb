class Episode < ActiveRecord::Base
  belongs_to :podcast
  has_many :show_notes

  attr_accessible :description, :file, :playtime, :number, :podcast_id, :podcast, :title, :slug, :created_at, :show_notes_attributes
  accepts_nested_attributes_for :show_notes, :allow_destroy => true

  has_attached_file :file,
                    :default_url => :set_default_url

  extend FriendlyId
  friendly_id :number, use: :slugged

  after_create :set_episode_number

  def num
    if number < 10
      return "00#{number}"
    elsif number < 100
      return "0#{number}"
    else
      return number
    end      
  end 

  private

  def set_episode_number
    if number == nil
      if podcast.episodes.size > 1
        update_column(:number, podcast.episodes.order("number desc").offset(1).first.number + 1)
      else
        update_column(:number, 1)
      end
    end
  end

  def set_default_url
    "http://www.talesofinterest.de/podcasts/#{podcast.name.underscore}#{num}.m4a"
  end
end
