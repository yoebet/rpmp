class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.integer :project_id
      t.integer :goal_id
      t.string :version
      t.integer :registrar_id
      t.boolean :confirmed
      t.string :memo
      t.integer :attachments_count

      t.timestamps
    end
  end
end
