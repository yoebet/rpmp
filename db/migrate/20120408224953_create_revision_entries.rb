class CreateRevisionEntries < ActiveRecord::Migration
  def change
    create_table :revision_entries do |t|
      t.integer :project_id
      t.integer :revision_id
      t.string :kind
      t.string :action
      t.string :path
    end

    add_index :revision_entries, [:project_id,:revision_id], :name => 'idx_revision_entries_pr'
    add_index :revision_entries, [:project_id,:path], :name => 'idx_revision_entries_pp'
  end
end
