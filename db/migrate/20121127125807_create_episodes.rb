class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :number
      t.string :title
      t.text :description
      t.integer :length
      t.string :episode_url
      t.integer :podcast_id
      t.string :slug

      t.timestamps
    end
  end
end
