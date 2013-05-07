class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :project_id
      t.integer :modu_id
      t.integer :priority
      t.integer :recipient_id
      t.string :abstract
      t.text :content
      t.date :expected_start_on
      t.date :expected_finish_on
      t.float :expected_days
      t.integer :registrar_id
      t.integer :status
      t.boolean :long_term
      t.string :memo
      t.integer :attachments_count
      t.integer :comments_count
      t.integer :tags_count
      t.integer :issues_count

      t.text :comprehension
      t.text :work_record
      t.date :actual_start_on
      t.date :actual_finish_on

      t.float :approved_days
      t.integer :work_rank
      t.string :rank_memo
      t.boolean :confirmed

      t.timestamps
    end

    add_index :tasks, [:project_id, :recipient_id], :name => 'idx_tas_pr'
    add_index :tasks, [:project_id, :expected_start_on], :name => 'idx_tas_pes'
    add_index :tasks, [:project_id, :actual_start_on], :name => 'idx_tas_pas'
  end
end
