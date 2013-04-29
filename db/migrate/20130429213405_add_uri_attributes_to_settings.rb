class AddUriAttributesToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :uri_key, :string
    add_column :settings, :uri_token, :string
  end
end
