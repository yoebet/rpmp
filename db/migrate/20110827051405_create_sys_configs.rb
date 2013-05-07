class CreateSysConfigs < ActiveRecord::Migration
  def change
    create_table :sys_configs do |t|
      t.string :name
      t.string :zh_name
      t.string :value
      t.string :memo

      t.timestamps
    end
  end
end
