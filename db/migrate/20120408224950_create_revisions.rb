class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.integer :project_id
      t.integer :revision_no
      t.string :author
      t.datetime :commit_at
      t.text :commit_comment
      t.integer :revision_entries_count

      t.datetime :created_at
    end

    add_index :revisions, [:project_id,:revision_no], :name => 'idx_revisions_pr'
  end
end
