class CreateSysProjMods < ActiveRecord::Migration
  def change
    create_table :sys_proj_mods do |t|
      t.integer :project_id
      t.integer :mod_id
      t.datetime :created_at
    end
  end
end
