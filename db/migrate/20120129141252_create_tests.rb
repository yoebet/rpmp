class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.integer :project_id
      t.integer :release_id
      t.integer :head_id
      t.string :abstract
      t.text :content
      t.string :test_plan
      t.text :test_record
      t.string :conclusion
      t.integer :status
      t.integer :registrar_id
      t.string :memo
      t.integer :issues_count
      t.integer :attachments_count
      t.integer :comments_count
      t.integer :tags_count
      t.boolean :confirmed

      t.timestamps
    end
  end
end
