class AddPositionToShowNotes < ActiveRecord::Migration
  def change
    add_column :show_notes, :position, :integer
  end
end
