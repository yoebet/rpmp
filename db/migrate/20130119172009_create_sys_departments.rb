class CreateSysDepartments < ActiveRecord::Migration
  def change
    create_table :sys_departments do |t|
      t.string :code
      t.string :name
      t.string :description
      t.integer :s_order

      t.timestamps
    end
  end
end
