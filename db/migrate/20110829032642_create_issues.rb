class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :project_id
      t.integer :modu_id
      t.string :raised_by_type
      t.integer :raised_by_id
      t.integer :registrar_id
      t.integer :release_id
      t.integer :test_id
      t.integer :issue_type
      t.integer :urgency
      t.string :abstract
      t.text :content
      t.integer :status
      t.string :cause
      t.text :solution
      t.string :memo
      t.boolean :confirmed
      t.integer :attachments_count
      t.integer :comments_count
      t.integer :tags_count

      t.integer :solved_by_id
      t.timestamp :solved_at
      t.integer :test_by_id
      t.text :test_memo
      t.integer :closed_by_id
      t.timestamp :closed_at

      t.timestamps
    end
  end
end
