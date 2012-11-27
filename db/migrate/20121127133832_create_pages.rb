class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :titel
      t.text :content
      t.string :slug

      t.timestamps
    end
  end
end
