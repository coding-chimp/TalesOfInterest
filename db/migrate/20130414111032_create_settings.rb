class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :site_name
      t.integer :posts_per_page
      t.attachment :favicon
      t.string :ga_code
      t.string :flattr_code
      t.string :feed_language
      t.string :feed_email
      t.string :feed_author

      t.timestamps
    end
  end
end
