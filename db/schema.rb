# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130314111245) do

  create_table "activities", :force => true do |t|
    t.integer  "project_id"
    t.string   "subject_type"
    t.integer  "subject_id"
    t.integer  "user_id"
    t.string   "action"
    t.datetime "created_at"
    t.string   "abstract"
  end

  add_index "activities", ["project_id", "subject_type", "subject_id"], :name => "idx_activity_pss"

  create_table "associations", :force => true do |t|
    t.integer  "project_id"
    t.string   "subject_type"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.string   "target_type",  :limit => 30
    t.integer  "target_id"
    t.string   "label"
  end

  add_index "associations", ["subject_type", "subject_id"], :name => "idx_ass_ss"
  add_index "associations", ["target_type", "target_id"], :name => "idx_ass_tt"

  create_table "attachments", :force => true do |t|
    t.integer  "project_id"
    t.string   "subject_type"
    t.integer  "subject_id"
    t.string   "name"
    t.string   "content_type"
    t.integer  "content_size"
    t.binary   "content",      :limit => 16777215
    t.string   "memo"
    t.datetime "created_at"
    t.boolean  "image"
    t.integer  "image_width"
    t.integer  "image_height"
    t.integer  "presenter_id"
    t.string   "tag"
  end

  add_index "attachments", ["project_id", "subject_type", "subject_id"], :name => "idx_atm_pss"

  create_table "comments", :force => true do |t|
    t.integer  "project_id"
    t.string   "subject_type"
    t.integer  "subject_id"
    t.string   "title",        :limit => 50, :default => ""
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "comments", ["project_id", "subject_type", "subject_id"], :name => "idx_com_pss"

  create_table "communications", :force => true do |t|
    t.integer  "project_id"
    t.date     "communicate_on"
    t.integer  "communicate_type"
    t.integer  "customer_id"
    t.string   "abstract"
    t.text     "content"
    t.string   "memo"
    t.boolean  "confirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attachments_count"
    t.integer  "registrar_id"
    t.integer  "comments_count"
    t.integer  "tags_count"
  end

  create_table "customers", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.string   "organ"
    t.string   "department"
    t.string   "title"
    t.string   "phone"
    t.string   "email"
    t.string   "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "registrar_id"
  end

  create_table "documents", :force => true do |t|
    t.integer  "project_id"
    t.string   "abstract"
    t.text     "content"
    t.string   "memo"
    t.integer  "status"
    t.string   "scm_path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attachments_count"
    t.integer  "registrar_id"
    t.integer  "comments_count"
    t.integer  "tags_count"
  end

  create_table "goals", :force => true do |t|
    t.integer  "project_id"
    t.string   "version"
    t.string   "abstract"
    t.text     "content"
    t.date     "release_on"
    t.integer  "version_type"
    t.integer  "importance"
    t.boolean  "confirmed"
    t.string   "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
    t.integer  "releases_count"
    t.integer  "registrar_id"
    t.integer  "comments_count"
  end

  create_table "issues", :force => true do |t|
    t.integer  "project_id"
    t.integer  "registrar_id"
    t.integer  "issue_type"
    t.integer  "urgency"
    t.integer  "status"
    t.string   "abstract"
    t.text     "content"
    t.string   "memo"
    t.boolean  "confirmed"
    t.integer  "attachments_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "release_id"
    t.integer  "test_id"
    t.integer  "fixes_count"
    t.integer  "comments_count"
    t.integer  "tags_count"
    t.string   "cause"
    t.text     "solution"
    t.integer  "solved_by_id"
    t.integer  "test_by_id"
    t.text     "test_memo",         :limit => 16777215
    t.datetime "solved_at"
    t.integer  "closed_by_id"
    t.datetime "closed_at"
    t.integer  "modu_id"
    t.integer  "raised_by_id"
    t.string   "raised_by_type"
  end

  create_table "meetings", :force => true do |t|
    t.integer  "project_id"
    t.date     "holding_on"
    t.integer  "emcee_id"
    t.string   "abstract"
    t.text     "content"
    t.integer  "registrar_id"
    t.boolean  "confirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "memo"
    t.integer  "attachments_count"
    t.integer  "comments_count"
    t.integer  "tags_count"
  end

  create_table "message_receives", :force => true do |t|
    t.integer  "message_id"
    t.integer  "receiver_id"
    t.boolean  "read"
    t.boolean  "replied"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "message_receives", ["message_id", "receiver_id"], :name => "idx_message_receives_mr"
  add_index "message_receives", ["receiver_id", "id"], :name => "idx_message_receives_ri"

  create_table "messages", :force => true do |t|
    t.string   "title"
    t.text     "content",                :limit => 16777215
    t.integer  "sender_id"
    t.integer  "replied_message_id"
    t.integer  "reply_messages_count"
    t.integer  "message_receives_count"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "messages", ["sender_id", "id"], :name => "idx_messages_si"

  create_table "releases", :force => true do |t|
    t.integer  "project_id"
    t.integer  "goal_id"
    t.string   "version"
    t.integer  "registrar_id"
    t.boolean  "confirmed"
    t.string   "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attachments_count"
  end

  create_table "requirements", :force => true do |t|
    t.integer  "project_id"
    t.integer  "registrar_id"
    t.integer  "importance"
    t.integer  "status"
    t.string   "abstract"
    t.text     "content"
    t.string   "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "raised_on"
    t.boolean  "confirmed"
    t.integer  "attachments_count"
    t.integer  "comments_count"
    t.integer  "tags_count"
    t.boolean  "original"
    t.integer  "modu_id"
    t.integer  "raised_by_id"
    t.string   "raised_by_type"
  end

  create_table "revision_entries", :force => true do |t|
    t.integer "project_id"
    t.integer "revision_id"
    t.string  "kind"
    t.string  "action"
    t.string  "path"
  end

  add_index "revision_entries", ["project_id", "path"], :name => "idx_revision_entries_pp"
  add_index "revision_entries", ["project_id", "revision_id"], :name => "idx_revision_entries_pr"

  create_table "revisions", :force => true do |t|
    t.integer  "project_id"
    t.integer  "revision_no"
    t.string   "author"
    t.datetime "commit_at"
    t.integer  "revision_entries_count"
    t.datetime "created_at"
    t.text     "commit_comment",         :limit => 16777215
  end

  add_index "revisions", ["project_id", "revision_no"], :name => "idx_revisions_pr"

  create_table "sys_announcement_reads", :force => true do |t|
    t.integer  "announcement_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "sys_announcements", :force => true do |t|
    t.string   "title"
    t.string   "sub_title"
    t.string   "content_format"
    t.text     "content",        :limit => 16777215
    t.string   "inscribe"
    t.date     "inscribe_date"
    t.integer  "post_by_id"
    t.string   "memo"
    t.integer  "status"
    t.date     "expire_on"
    t.boolean  "current"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "sys_configs", :force => true do |t|
    t.string   "name"
    t.string   "zh_name"
    t.string   "value"
    t.string   "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sys_departments", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "description"
    t.integer  "s_order"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "sys_logs", :force => true do |t|
    t.string   "subject_type"
    t.integer  "subject_id"
    t.integer  "user_id"
    t.string   "user_ip"
    t.string   "action"
    t.string   "abstract"
    t.datetime "created_at"
  end

  create_table "sys_mods", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "description"
    t.boolean  "def_included"
    t.integer  "s_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sys_proj_member_roles", :force => true do |t|
    t.integer  "project_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.integer  "user_id"
  end

  create_table "sys_proj_mods", :force => true do |t|
    t.integer  "project_id"
    t.integer  "mod_id"
    t.datetime "created_at"
  end

  create_table "sys_projects", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.text     "description"
    t.string   "scm"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "major"
    t.boolean  "inactive"
  end

  create_table "sys_roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "s_order"
  end

  create_table "sys_users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "salt"
    t.string   "hashed_password"
    t.integer  "sysrole"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
    t.string   "scm_username"
    t.boolean  "announcement_notify"
    t.integer  "s_order"
    t.boolean  "password_must_update"
  end

  create_table "tags", :force => true do |t|
    t.integer  "project_id"
    t.string   "subject_type"
    t.integer  "subject_id"
    t.string   "name",         :limit => 10
    t.integer  "user_id"
    t.datetime "created_at"
  end

  add_index "tags", ["project_id", "name", "subject_type"], :name => "idx_tag_pns"
  add_index "tags", ["project_id", "subject_type", "subject_id"], :name => "idx_tag_pss"

  create_table "tasks", :force => true do |t|
    t.integer  "project_id"
    t.integer  "priority"
    t.integer  "recipient_id"
    t.string   "abstract"
    t.text     "content"
    t.date     "expected_start_on"
    t.date     "expected_finish_on"
    t.float    "expected_days"
    t.integer  "registrar_id"
    t.integer  "status"
    t.string   "memo"
    t.integer  "attachments_count"
    t.text     "work_record"
    t.date     "actual_start_on"
    t.date     "actual_finish_on"
    t.float    "approved_days"
    t.integer  "work_rank"
    t.string   "rank_memo"
    t.boolean  "confirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count"
    t.integer  "tags_count"
    t.boolean  "long_term"
    t.text     "comprehension"
    t.integer  "issues_count"
    t.integer  "modu_id"
  end

  add_index "tasks", ["project_id", "actual_start_on"], :name => "idx_tas_pas"
  add_index "tasks", ["project_id", "expected_start_on"], :name => "idx_tas_pes"
  add_index "tasks", ["project_id", "recipient_id"], :name => "idx_tas_pr"

  create_table "tests", :force => true do |t|
    t.integer  "project_id"
    t.integer  "release_id"
    t.integer  "head_id"
    t.string   "abstract"
    t.text     "content"
    t.string   "conclusion"
    t.integer  "status"
    t.integer  "registrar_id"
    t.string   "memo"
    t.integer  "issues_count"
    t.boolean  "confirmed"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "comments_count"
    t.integer  "tags_count"
    t.integer  "attachments_count"
    t.string   "test_plan"
    t.text     "test_record"
  end

  create_table "weeklies", :force => true do |t|
    t.integer  "project_id"
    t.integer  "registrar_id"
    t.date     "weekend"
    t.text     "review"
    t.text     "thought"
    t.text     "plan"
    t.string   "memo"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.boolean  "confirmed"
    t.integer  "comments_count"
  end

  add_index "weeklies", ["project_id", "registrar_id", "weekend"], :name => "idx_wee_puw"

end
