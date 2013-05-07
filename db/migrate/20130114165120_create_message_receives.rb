class CreateMessageReceives < ActiveRecord::Migration
  def change
    create_table :message_receives do |t|
      t.integer :message_id
      t.integer :receiver_id
      t.boolean :read
      t.boolean :replied

      t.timestamps
    end

    add_index :message_receives, [:message_id,:receiver_id], :name => 'idx_message_receives_mr'
    add_index :message_receives, [:receiver_id,:id], :name => 'idx_message_receives_ri'
  end
end
