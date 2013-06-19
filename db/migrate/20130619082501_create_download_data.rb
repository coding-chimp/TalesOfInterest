class CreateDownloadData < ActiveRecord::Migration
  def change
    create_table :download_data do |t|
      t.date :date
      t.integer :audio_file_id
      t.integer :downloaded
      t.integer :hits

      t.timestamps
    end
  end
end
