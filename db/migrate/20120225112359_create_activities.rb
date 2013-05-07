class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :project_id
      t.string :subject_type
      t.integer :subject_id
      t.integer :user_id
      t.string :action
      t.string :abstract

      t.datetime :created_at
    end

    add_index :activities, [:project_id,:subject_type,:subject_id], :name => 'idx_activity_pss'
  end
end
