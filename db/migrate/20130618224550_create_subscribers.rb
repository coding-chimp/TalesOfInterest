class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.date :date
      t.integer :count
      t.string :reader
      t.integer :podcast_id

      t.timestamps
    end
  end
end
