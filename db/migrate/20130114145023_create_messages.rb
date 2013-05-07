class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.text :content
      t.integer :sender_id
      t.integer :replied_message_id
      t.integer :reply_messages_count
      t.integer :message_receives_count

      t.timestamps
    end

    add_index :messages, [:sender_id,:id], :name => 'idx_messages_si'
  end
end
