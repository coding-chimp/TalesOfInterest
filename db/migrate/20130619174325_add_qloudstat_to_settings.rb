class AddQloudstatToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :qloudstat_api_key, :string
    add_column :settings, :qloudstat_api_secret, :string
  end
end
