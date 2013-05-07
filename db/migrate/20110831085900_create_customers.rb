class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :project_id
      t.string :name
      t.string :organ
      t.string :department
      t.string :title
      t.string :phone
      t.string :email
      t.integer :registrar_id
      t.string :memo

      t.timestamps
    end
  end
end
