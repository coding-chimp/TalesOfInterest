class AddAnalyticsValuesToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :hits, :integer
    add_column :episodes, :downloaded, :integer, :limit => 8
    add_column :episodes, :downloads, :integer
  end
end
