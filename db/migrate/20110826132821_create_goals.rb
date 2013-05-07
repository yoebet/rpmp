class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :project_id
      t.string :version
      t.string :abstract
      t.text :content
      t.date :release_on
      t.integer :version_type
      t.integer :importance
      t.integer :status
      t.boolean :confirmed
      t.string :memo
      t.integer :releases_count
      t.integer :comments_count
      t.integer :registrar_id

      t.timestamps
    end
  end
end
