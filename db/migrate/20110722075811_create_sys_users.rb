class CreateSysUsers < ActiveRecord::Migration
  def change
    create_table :sys_users do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :salt
      t.string :hashed_password
      t.integer :sysrole
      t.boolean :enabled

      t.integer :s_order
      t.integer :department_id
      t.string :scm_username
      t.boolean :announcement_notify
      t.boolean :password_must_update

      t.timestamps
    end
  end
end
