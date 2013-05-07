class CreateAssociations < ActiveRecord::Migration
  def change
    create_table :associations do |t|
      t.integer :project_id
      t.string :subject_type
      t.integer :subject_id
      t.string :target_type
      t.string :label
      t.integer :target_id
      t.datetime :created_at
    end

    add_index :associations, [:subject_type,:subject_id], :name => 'idx_ass_ss'
    add_index :associations, [:target_type,:target_id], :name => 'idx_ass_tt'
  end
end
