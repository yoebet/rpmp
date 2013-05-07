class CreateSysAnnouncements < ActiveRecord::Migration
  def change
    create_table :sys_announcements do |t|
      t.string :title
      t.string :sub_title
      t.string :content_format
      t.text :content
      t.string :inscribe
      t.date :inscribe_date
      t.integer :post_by_id
      t.string :memo
      t.integer :status
      t.date :expire_on
      t.boolean :current

      t.timestamps
    end

  end
end
