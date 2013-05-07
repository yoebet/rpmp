class CreateWeeklies < ActiveRecord::Migration
  def change
    create_table :weeklies do |t|
      t.integer :project_id
      t.integer :registrar_id
      t.date :weekend
      t.text :review
      t.text :thought
      t.text :plan
      t.boolean :confirmed
      t.string :memo
      t.integer :comments_count

      t.timestamps
    end

    add_index :weeklies, [:project_id, :registrar_id, :weekend], :name => 'idx_wee_puw'
  end
end
