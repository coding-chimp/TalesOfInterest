class AddGaugesKeyToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :gauges_key, :string
  end
end
