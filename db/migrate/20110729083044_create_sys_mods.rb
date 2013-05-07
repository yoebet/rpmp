class CreateSysMods < ActiveRecord::Migration
  def change
    create_table :sys_mods do |t|
      t.string :code
      t.string :name
      t.string :description
      t.boolean :def_included
      t.integer :s_order

      t.timestamps
    end
  end
end
