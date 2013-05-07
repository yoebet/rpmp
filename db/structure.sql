CREATE TABLE `activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `subject_type` varchar(255) DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `abstract` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_activity_pss` (`project_id`,`subject_type`,`subject_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6737 DEFAULT CHARSET=utf8;

CREATE TABLE `associations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `subject_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `target_type` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `label` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ass_ss` (`subject_type`,`subject_id`),
  KEY `idx_ass_tt` (`target_type`,`target_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1345 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `subject_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_size` int(11) DEFAULT NULL,
  `content` mediumblob,
  `memo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `image` tinyint(1) DEFAULT NULL,
  `image_width` int(11) DEFAULT NULL,
  `image_height` int(11) DEFAULT NULL,
  `presenter_id` int(11) DEFAULT NULL,
  `tag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_atm_pss` (`project_id`,`subject_type`,`subject_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `subject_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `title` varchar(50) COLLATE utf8_unicode_ci DEFAULT '',
  `content` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_com_pss` (`project_id`,`subject_type`,`subject_id`)
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `communications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `communicate_on` date DEFAULT NULL,
  `communicate_type` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `abstract` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `memo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmed` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `attachments_count` int(11) DEFAULT NULL,
  `registrar_id` int(11) DEFAULT NULL,
  `comments_count` int(11) DEFAULT NULL,
  `tags_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `organ` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `department` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `memo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `registrar_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `abstract` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `memo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `scm_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `attachments_count` int(11) DEFAULT NULL,
  `registrar_id` int(11) DEFAULT NULL,
  `comments_count` int(11) DEFAULT NULL,
  `tags_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `goals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `abstract` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `release_on` date DEFAULT NULL,
  `version_type` int(11) DEFAULT NULL,
  `importance` int(11) DEFAULT NULL,
  `confirmed` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `releases_count` int(11) DEFAULT NULL,
  `registrar_id` int(11) DEFAULT NULL,
  `comments_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `issues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `registrar_id` int(11) DEFAULT NULL,
  `issue_type` int(11) DEFAULT NULL,
  `urgency` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `abstract` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `memo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmed` tinyint(1) DEFAULT NULL,
  `attachments_count` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `release_id` int(11) DEFAULT NULL,
  `test_id` int(11) DEFAULT NULL,
  `fixes_count` int(11) DEFAULT NULL,
  `comments_count` int(11) DEFAULT NULL,
  `tags_count` int(11) DEFAULT NULL,
  `cause` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `solution` text COLLATE utf8_unicode_ci,
  `solved_by_id` int(11) DEFAULT NULL,
  `test_by_id` int(11) DEFAULT NULL,
  `test_memo` mediumtext COLLATE utf8_unicode_ci,
  `solved_at` datetime DEFAULT NULL,
  `closed_by_id` int(11) DEFAULT NULL,
  `closed_at` datetime DEFAULT NULL,
  `modu_id` int(11) DEFAULT NULL,
  `raised_by_id` int(11) DEFAULT NULL,
  `raised_by_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=480 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `meetings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `holding_on` date DEFAULT NULL,
  `emcee_id` int(11) DEFAULT NULL,
  `abstract` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `registrar_id` int(11) DEFAULT NULL,
  `confirmed` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `memo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attachments_count` int(11) DEFAULT NULL,
  `comments_count` int(11) DEFAULT NULL,
  `tags_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `message_receives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message_id` int(11) DEFAULT NULL,
  `receiver_id` int(11) DEFAULT NULL,
  `read` tinyint(1) DEFAULT NULL,
  `replied` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_message_receives_mr` (`message_id`,`receiver_id`),
  KEY `idx_message_receives_ri` (`receiver_id`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `content` mediumtext,
  `sender_id` int(11) DEFAULT NULL,
  `replied_message_id` int(11) DEFAULT NULL,
  `reply_messages_count` int(11) DEFAULT NULL,
  `message_receives_count` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_messages_si` (`sender_id`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

CREATE TABLE `modus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `tasks_count` int(11) DEFAULT NULL,
  `issues_count` int(11) DEFAULT NULL,
  `requirements_count` int(11) DEFAULT NULL,
  `s_order` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `releases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `goal_id` int(11) DEFAULT NULL,
  `version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `registrar_id` int(11) DEFAULT NULL,
  `confirmed` tinyint(1) DEFAULT NULL,
  `memo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `attachments_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `requirements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `registrar_id` int(11) DEFAULT NULL,
  `importance` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `abstract` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `memo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `raised_on` date DEFAULT NULL,
  `confirmed` tinyint(1) DEFAULT NULL,
  `attachments_count` int(11) DEFAULT NULL,
  `comments_count` int(11) DEFAULT NULL,
  `tags_count` int(11) DEFAULT NULL,
  `original` tinyint(1) DEFAULT NULL,
  `modu_id` int(11) DEFAULT NULL,
  `raised_by_id` int(11) DEFAULT NULL,
  `raised_by_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `revision_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `revision_id` int(11) DEFAULT NULL,
  `kind` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_revision_entries_pr` (`project_id`,`revision_id`),
  KEY `idx_revision_entries_pp` (`project_id`,`path`)
) ENGINE=InnoDB AUTO_INCREMENT=119240 DEFAULT CHARSET=utf8;

CREATE TABLE `revisions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `revision_no` int(11) DEFAULT NULL,
  `author` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `commit_at` datetime DEFAULT NULL,
  `revision_entries_count` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `commit_comment` mediumtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `idx_revisions_pr` (`project_id`,`revision_no`)
) ENGINE=MyISAM AUTO_INCREMENT=20508 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sys_announcement_reads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `announcement_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `sys_announcements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `sub_title` varchar(255) DEFAULT NULL,
  `content_format` varchar(255) DEFAULT NULL,
  `content` mediumtext,
  `inscribe` varchar(255) DEFAULT NULL,
  `inscribe_date` date DEFAULT NULL,
  `post_by_id` int(11) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `expire_on` date DEFAULT NULL,
  `current` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `sys_configs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zh_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `memo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sys_departments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `s_order` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sys_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `abstract` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sys_mods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `def_included` tinyint(1) DEFAULT NULL,
  `s_order` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sys_proj_member_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=421 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sys_proj_mods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `mod_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1163 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sys_projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `scm` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `major` tinyint(1) DEFAULT NULL,
  `inactive` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sys_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `s_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sys_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `salt` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `hashed_password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sysrole` int(11) DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `scm_username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `announcement_notify` tinyint(1) DEFAULT NULL,
  `s_order` int(11) DEFAULT NULL,
  `password_must_update` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `subject_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `name` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tag_pss` (`project_id`,`subject_type`,`subject_id`),
  KEY `idx_tag_pns` (`project_id`,`name`,`subject_type`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `abstract` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `expected_start_on` date DEFAULT NULL,
  `expected_finish_on` date DEFAULT NULL,
  `expected_days` float DEFAULT NULL,
  `registrar_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `memo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attachments_count` int(11) DEFAULT NULL,
  `work_record` text COLLATE utf8_unicode_ci,
  `actual_start_on` date DEFAULT NULL,
  `actual_finish_on` date DEFAULT NULL,
  `approved_days` float DEFAULT NULL,
  `work_rank` int(11) DEFAULT NULL,
  `rank_memo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmed` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `comments_count` int(11) DEFAULT NULL,
  `tags_count` int(11) DEFAULT NULL,
  `long_term` tinyint(1) DEFAULT NULL,
  `comprehension` text COLLATE utf8_unicode_ci,
  `issues_count` int(11) DEFAULT NULL,
  `modu_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tas_pr` (`project_id`,`recipient_id`),
  KEY `idx_tas_pes` (`project_id`,`expected_start_on`),
  KEY `idx_tas_pas` (`project_id`,`actual_start_on`)
) ENGINE=InnoDB AUTO_INCREMENT=1134 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `release_id` int(11) DEFAULT NULL,
  `head_id` int(11) DEFAULT NULL,
  `abstract` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `conclusion` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `registrar_id` int(11) DEFAULT NULL,
  `memo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `issues_count` int(11) DEFAULT NULL,
  `confirmed` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `comments_count` int(11) DEFAULT NULL,
  `tags_count` int(11) DEFAULT NULL,
  `attachments_count` int(11) DEFAULT NULL,
  `test_plan` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `test_record` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `weeklies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `registrar_id` int(11) DEFAULT NULL,
  `weekend` date DEFAULT NULL,
  `review` text COLLATE utf8_unicode_ci,
  `thought` text COLLATE utf8_unicode_ci,
  `plan` text COLLATE utf8_unicode_ci,
  `memo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `confirmed` tinyint(1) DEFAULT NULL,
  `comments_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_wee_puw` (`project_id`,`registrar_id`,`weekend`)
) ENGINE=InnoDB AUTO_INCREMENT=457 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20110722075811');

INSERT INTO schema_migrations (version) VALUES ('20110727094955');

INSERT INTO schema_migrations (version) VALUES ('20110729083044');

INSERT INTO schema_migrations (version) VALUES ('20110804092532');

INSERT INTO schema_migrations (version) VALUES ('20110805053542');

INSERT INTO schema_migrations (version) VALUES ('20110805060600');

INSERT INTO schema_migrations (version) VALUES ('20110815072406');

INSERT INTO schema_migrations (version) VALUES ('20110816064144');

INSERT INTO schema_migrations (version) VALUES ('20110826132821');

INSERT INTO schema_migrations (version) VALUES ('20110827042112');

INSERT INTO schema_migrations (version) VALUES ('20110827051405');

INSERT INTO schema_migrations (version) VALUES ('20110827062207');

INSERT INTO schema_migrations (version) VALUES ('20110828033832');

INSERT INTO schema_migrations (version) VALUES ('20110829032642');

INSERT INTO schema_migrations (version) VALUES ('20110830031207');

INSERT INTO schema_migrations (version) VALUES ('20110831085900');

INSERT INTO schema_migrations (version) VALUES ('20110901104321');

INSERT INTO schema_migrations (version) VALUES ('20110902113354');

INSERT INTO schema_migrations (version) VALUES ('20120123144340');

INSERT INTO schema_migrations (version) VALUES ('20120124104707');

INSERT INTO schema_migrations (version) VALUES ('20120125064144');

INSERT INTO schema_migrations (version) VALUES ('20120129141252');

INSERT INTO schema_migrations (version) VALUES ('20120225112359');

INSERT INTO schema_migrations (version) VALUES ('20120408224950');

INSERT INTO schema_migrations (version) VALUES ('20120408224953');

INSERT INTO schema_migrations (version) VALUES ('20130111143700');

INSERT INTO schema_migrations (version) VALUES ('20130111143810');

INSERT INTO schema_migrations (version) VALUES ('20130114145023');

INSERT INTO schema_migrations (version) VALUES ('20130114165120');

INSERT INTO schema_migrations (version) VALUES ('20130119172009');

INSERT INTO schema_migrations (version) VALUES ('20130122152646');

INSERT INTO schema_migrations (version) VALUES ('20130314111245');