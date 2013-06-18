class CreateTraffics < ActiveRecord::Migration
  def change
    create_table :traffics do |t|
      t.integer :views
      t.integer :people
      t.date :date

      t.timestamps
    end
  end
end
