class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :number
      t.string :title
      t.text :description
      t.integer :playtime
      t.string :file
      t.integer :file_size
      t.boolean :explicit
      t.integer :podcast_id
      t.string :slug

      t.timestamps
    end
  end
end
