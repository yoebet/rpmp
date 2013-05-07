class CreateSysLogs < ActiveRecord::Migration
  def change
    create_table :sys_logs, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci' do |t|
      t.string :subject_type
      t.integer :subject_id
      t.integer :user_id
      t.string :user_ip
      t.string :action
      t.string :abstract

      t.datetime :created_at
    end
  end
end
