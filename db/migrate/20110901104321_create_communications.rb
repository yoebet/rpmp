class CreateCommunications < ActiveRecord::Migration
  def change
    create_table :communications do |t|
      t.integer :project_id
      t.date :communicate_on
      t.integer :communicate_type
      t.integer :customer_id
      t.string :abstract
      t.text :content
      t.string :memo
      t.integer :registrar_id
      t.boolean :confirmed
      t.integer :attachments_count
      t.integer :comments_count
      t.integer :tags_count

      t.timestamps
    end
  end
end

