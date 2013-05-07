class CreateSysRoles < ActiveRecord::Migration
  def change
    create_table :sys_roles do |t|
      t.string :name
      t.string :description
      t.integer :s_order

      t.timestamps
    end
  end
end
