class CreateModus < ActiveRecord::Migration
  def change
    create_table :modus, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci' do |t|
      t.string :name
      t.string :description
      t.integer :project_id
      t.integer :tasks_count
      t.integer :issues_count
      t.integer :requirements_count
      t.integer :s_order

      t.timestamps
    end
  end
end
