class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :project_id
      t.string :subject_type
      t.integer :subject_id
      t.integer :presenter_id
      t.string :name
      t.string :content_type
      t.integer :content_size
      t.binary :content, :limit => 16*2**20
      # t.binary :content
      t.boolean :image
      t.integer :image_width
      t.integer :image_height
      t.string :tag
      t.string :memo

      t.datetime :created_at
    end

    add_index :attachments, [:project_id,:subject_type,:subject_id], :name => 'idx_atm_pss'
  end
end
