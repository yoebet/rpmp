class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :project_id
      t.string :subject_type
      t.integer :subject_id
      t.string :title, :limit => 50, :default => "" 
      t.text :content
      t.integer :user_id
      t.timestamps
    end

    add_index :comments, [:project_id,:subject_type,:subject_id], :name => 'idx_com_pss'
  end
end
