class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.integer :project_id
      t.integer :modu_id
      t.string :raised_by_type
      t.integer :raised_by_id
      t.date :raised_on
      t.integer :registrar_id
      t.integer :importance
      t.integer :status
      t.string :abstract
      t.text :content
      t.string :memo
      t.integer :attachments_count
      t.integer :comments_count
      t.integer :tags_count
      t.boolean :original
      t.boolean :confirmed

      t.timestamps
    end
  end
end
