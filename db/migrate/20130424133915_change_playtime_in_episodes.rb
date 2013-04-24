class ChangePlaytimeInEpisodes < ActiveRecord::Migration
  def up
  	connection.execute(%q{
  		ALTER TABLE episodes
  		ALTER COLUMN playtime
  		TYPE integer USING CAST(CASE playtime WHEN '' THEN NULL ELSE playtime END AS INTEGER)
  	})
  end

  def down
  end
end
