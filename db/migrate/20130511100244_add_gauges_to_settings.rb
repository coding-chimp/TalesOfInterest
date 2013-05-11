class AddGaugesToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :gauges, :string
  end
end
