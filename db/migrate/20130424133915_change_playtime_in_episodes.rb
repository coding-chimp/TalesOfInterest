class ChangePlaytimeInEpisodes < ActiveRecord::Migration
  def up
  	connection.execute(%q{
  		alter table episodes
  		alter column playtime
  		type integer using cast(playtime as integer)
  	})
  end

  def down
  end
end
