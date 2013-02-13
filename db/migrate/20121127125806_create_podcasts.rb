class CreatePodcasts < ActiveRecord::Migration
  def change
    create_table :podcasts do |t|
      t.string :name
      t.text :description
      t.attachment :artwork
      t.string :author
      t.string :keywords
      t.boolean :explicit
      t.string :category
      t.string :slug

      t.timestamps
    end
  end
end
