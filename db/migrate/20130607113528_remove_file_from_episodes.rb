class RemoveFileFromEpisodes < ActiveRecord::Migration
  def up
    Episode.all.each do |episode|
      file = episode.file
      file_type = File.extname(URI.parse(file).path).gsub ".", ""
      if file_type == "m4a"
        file_type = "mp4"
      end
      AudioFile.create!(url: file, media_type: file_type, size: episode.file_size, episode_id: episode.id)
    end

    remove_column :episodes, :file
    remove_column :episodes, :file_size
  end

  def down
    add_column :episodes, :file, :string
    add_column :episodes, :file, :integer

    raise ActiveRecord::IrreversibleMigration, "Can't recover the removed files."
  end
end
