class CreateAudioFiles < ActiveRecord::Migration
  def change
    create_table :audio_files do |t|
      t.string :url
      t.string :media_type
      t.integer :size
      t.integer :episode_id

      t.timestamps
    end
  end
end
