class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :number
      t.string :title
      t.text :description
      t.integer :playtime
      t.attachment :file
      t.integer :podcast_id
      t.string :slug

      t.timestamps
    end
  end
end
