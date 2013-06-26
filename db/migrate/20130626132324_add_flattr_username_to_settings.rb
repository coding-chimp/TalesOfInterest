class AddFlattrUsernameToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :flattr_username, :string
    remove_column :settings, :flattr_code
  end
end
