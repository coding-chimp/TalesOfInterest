class DropIntroducedTitles < ActiveRecord::Migration
  def change
    IntroducedTitle.all.each do |it|
      ShowNote.create!(name: it.name, url: it.url, episode_id: it.episode_id)
    end

    drop_table :introduced_titles
  end
end