class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.integer :project_id
      t.date :holding_on
      t.integer :emcee_id
      t.string :abstract
      t.text :content
      t.integer :registrar_id
      t.string :memo
      t.boolean :confirmed
      t.integer :attachments_count
      t.integer :comments_count
      t.integer :tags_count

      t.timestamps
    end
  end
end
