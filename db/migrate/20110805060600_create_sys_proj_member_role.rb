class CreateSysProjMemberRole < ActiveRecord::Migration
  def change
    create_table :sys_proj_member_roles do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :role_id
      t.datetime :created_at
    end
  end
end
