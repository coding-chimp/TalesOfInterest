class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.integer :timestamp
      t.string :title
      t.integer :episode_id

      t.timestamps
    end
  end
end
