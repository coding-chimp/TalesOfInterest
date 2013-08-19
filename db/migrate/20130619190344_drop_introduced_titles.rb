class DropIntroducedTitles < ActiveRecord::Migration
  def change
    drop_table :introduced_titles
  end
end
