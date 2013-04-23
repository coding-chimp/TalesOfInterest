class CreateIntroducedTitles < ActiveRecord::Migration
  def change
    create_table :introduced_titles do |t|
      t.string :name
      t.string :url
      t.integer :episode_id

      t.timestamps
    end
  end
end
