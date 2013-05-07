class CreateSysProjects < ActiveRecord::Migration
  def change
    create_table :sys_projects do |t|
      t.string :name
      t.string :code
      t.text :description
      t.string :scm
      t.boolean :major
      t.boolean :inactive

      t.timestamps
    end
  end
end
