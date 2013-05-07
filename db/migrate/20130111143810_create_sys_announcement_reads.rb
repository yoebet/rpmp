class CreateSysAnnouncementReads < ActiveRecord::Migration
  def change
    create_table :sys_announcement_reads do |t|
      t.integer :announcement_id
      t.integer :user_id

      t.timestamps
    end

  end
end
