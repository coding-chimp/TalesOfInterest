class CreatePodcasts < ActiveRecord::Migration
  def change
    create_table :podcasts do |t|
      t.string :name
      t.text :description
      t.attachment :artwork
      t.string :author
      t.string :keywords
      t.boolean :explicit
      t.string :itunes_link
      t.string :category1
      t.string :category2
      t.string :category3
      t.string :slug

      t.timestamps
    end
  end
end
