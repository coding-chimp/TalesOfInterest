class CreateShowNotes < ActiveRecord::Migration
  def change
    create_table :show_notes do |t|
      t.string :name
      t.string :url
      t.integer :episode_id

      t.timestamps
    end
  end
end
