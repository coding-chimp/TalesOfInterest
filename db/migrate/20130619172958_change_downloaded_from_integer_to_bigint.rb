class ChangeDownloadedFromIntegerToBigint < ActiveRecord::Migration
  def change
    change_column :download_data, :downloaded, :integer, :limit => 8
  end
end
