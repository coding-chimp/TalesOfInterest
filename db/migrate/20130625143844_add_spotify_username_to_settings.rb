class AddSpotifyUsernameToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :spotify_username, :string
  end
end
