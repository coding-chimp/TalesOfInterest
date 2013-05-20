class AddSpotifyPlaylistToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :spotify_playlist, :string
  end
end
