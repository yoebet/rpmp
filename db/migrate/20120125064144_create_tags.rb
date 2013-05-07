class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :project_id
      t.string :subject_type
      t.integer :subject_id
      t.string :name, :limit => 20
      t.integer :user_id

      t.datetime :created_at
    end

    add_index :tags, [:project_id,:subject_type,:subject_id], :name => 'idx_tag_pss'
    add_index :tags, [:project_id,:name,:subject_type], :name => 'idx_tag_pns'
  end
end
