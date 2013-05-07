class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :project_id
      t.string :abstract
      t.text :content
      t.string :memo
      t.integer :status
      t.string :scm_path
      t.integer :attachments_count
      t.integer :comments_count
      t.integer :tags_count
      t.integer :registrar_id

      t.timestamps
    end
  end
end
