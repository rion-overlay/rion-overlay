DROP TABLE IF EXISTS acl;
CREATE TABLE acl (
  "name" varchar(200) NOT NULL,
  "value" varchar(200) NOT NULL,
  PRIMARY KEY  ("name")
);
DROP TABLE IF EXISTS aliases;
CREATE TABLE aliases (
  plugin smallint(6) NOT NULL,
  "storage" smallint(6) NOT NULL,
  "global" tinyint(1) NOT NULL default '0',
  "name" varchar(50) NOT NULL,
  "value" varchar(200) NOT NULL,
  PRIMARY KEY  (plugin,"storage","name")
);
DROP TABLE IF EXISTS conferences;
CREATE TABLE conferences (
  "name" varchar(50) NOT NULL,
  id bigint(20) unsigned NOT NULL auto_increment,
  nick varchar(50) NOT NULL,
  created timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  autojoin tinyint(1) NOT NULL default '1',
  online tinyint(1) NOT NULL default '0',
  joined timestamp NOT NULL default '0000-00-00 00:00:00',
  autoleave tinyint(1) NOT NULL default '1',
  owner varchar(200) default NULL,
  PRIMARY KEY  ("name"),
  UNIQUE KEY id (id),
  UNIQUE KEY id_2 (id)
);
DROP TABLE IF EXISTS conference_alists;
CREATE TABLE conference_alists (
  id bigint(20) unsigned NOT NULL auto_increment,
  conference_id int(11) NOT NULL,
  list smallint(6) NOT NULL,
  matcher smallint(6) NOT NULL default '0',
  test smallint(6) NOT NULL default '0',
  inv tinyint(1) NOT NULL default '0',
  "value" varchar(200) NOT NULL,
  child_id int(11) NOT NULL default '0',
  reason varchar(200) default NULL,
  expire timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (id),
  UNIQUE KEY id (id),
  UNIQUE KEY conference_id (conference_id,list,matcher,test,"value",child_id)
);
DROP TABLE IF EXISTS conference_jids;
CREATE TABLE conference_jids (
  id bigint(20) unsigned NOT NULL auto_increment,
  conference_id int(11) NOT NULL,
  jid varchar(50) NOT NULL,
  resource varchar(50) default NULL,
  "temporary" tinyint(1) NOT NULL default '0',
  created timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (id),
  UNIQUE KEY id (id),
  KEY conference_id (conference_id)
);
DROP TABLE IF EXISTS conference_jidstat;
CREATE TABLE conference_jidstat (
  id bigint(20) unsigned NOT NULL auto_increment,
  jid_id int(11) NOT NULL,
  time_online int(11) NOT NULL default '0',
  lastaction int(11) NOT NULL default '0',
  lastreason varchar(200) default NULL,
  msg_count int(11) NOT NULL default '0',
  msg_chars int(11) NOT NULL default '0',
  msg_words int(11) NOT NULL default '0',
  msg_sentences int(11) NOT NULL default '0',
  msg_me int(11) NOT NULL default '0',
  msg_reply int(11) NOT NULL default '0',
  msg_subject int(11) NOT NULL default '0',
  cnt_join int(11) NOT NULL default '0',
  cnt_leave int(11) NOT NULL default '0',
  cnt_presence int(11) NOT NULL default '0',
  cnt_nickchange int(11) NOT NULL default '0',
  cnt_visitor int(11) NOT NULL default '0',
  cnt_participant int(11) NOT NULL default '0',
  cnt_moderator int(11) NOT NULL default '0',
  cnt_noaffiliation int(11) NOT NULL default '0',
  cnt_member int(11) NOT NULL default '0',
  cnt_administrator int(11) NOT NULL default '0',
  cnt_owner int(11) NOT NULL default '0',
  cnt_kick int(11) NOT NULL default '0',
  cnt_ban int(11) NOT NULL default '0',
  ver_name varchar(50) default NULL,
  ver_version varchar(50) default NULL,
  ver_os varchar(200) default NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY id (id),
  UNIQUE KEY jid_id (jid_id)
);
DROP TABLE IF EXISTS conference_jidstat_time;
CREATE TABLE conference_jidstat_time (
  id bigint(20) unsigned NOT NULL auto_increment,
  jid_id int(11) NOT NULL,
  int_type int(11) NOT NULL,
  int_idx int(11) NOT NULL,
  "value" int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY id (id),
  UNIQUE KEY jid_id (jid_id,int_type,int_idx)
);
DROP TABLE IF EXISTS conference_log;
CREATE TABLE conference_log (
  id bigint(20) unsigned NOT NULL auto_increment,
  conference_id int(11) NOT NULL,
  "datetime" timestamp NOT NULL default CURRENT_TIMESTAMP,
  private tinyint(1) NOT NULL,
  nick_id int(11) NOT NULL,
  action_type int(11) NOT NULL,
  message varchar(500) NOT NULL,
  params varchar(100) default NULL,
  dst_nick_id int(11) default NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY id (id),
  KEY conference_id (conference_id),
  KEY nick_id (nick_id)
);
DROP TABLE IF EXISTS conference_nicks;
CREATE TABLE conference_nicks (
  id bigint(20) unsigned NOT NULL auto_increment,
  conference_id int(11) NOT NULL,
  nick varchar(50) NOT NULL,
  jid int(11) NOT NULL default '0',
  created timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  online tinyint(1) NOT NULL default '0',
  joined timestamp NOT NULL default '0000-00-00 00:00:00',
  lastaction timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (id),
  UNIQUE KEY id (id),
  KEY conference_id (conference_id),
  KEY jid (jid)
);
DROP TABLE IF EXISTS configuration;
CREATE TABLE configuration (
  plugin smallint(6) NOT NULL,
  "storage" smallint(6) NOT NULL,
  "name" varchar(50) NOT NULL,
  "value" varchar(250) NOT NULL,
  PRIMARY KEY  (plugin,"storage","name")
);
DROP TABLE IF EXISTS configuration_fields;
CREATE TABLE configuration_fields (
  plugin smallint(6) NOT NULL,
  "name" varchar(50) NOT NULL,
  priority smallint(6) NOT NULL default '0',
  field_type smallint(6) NOT NULL,
  description varchar(100) NOT NULL,
  default_value varchar(250) default NULL,
  PRIMARY KEY  (plugin,"name")
);
DROP TABLE IF EXISTS roster;
CREATE TABLE roster (
  id bigint(20) unsigned NOT NULL auto_increment,
  jid varchar(100) NOT NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY id (id),
  UNIQUE KEY jid (jid)
);
DROP TABLE IF EXISTS version;
CREATE TABLE version (
  "name" varchar(50) NOT NULL,
  "value" varchar(50) NOT NULL,
  PRIMARY KEY  ("name")
);
INSERT INTO version VALUES('dbversion', '401');
DROP TABLE IF EXISTS webstatus;
CREATE TABLE webstatus (
  jid varchar(50) NOT NULL,
  "hash" varchar(50) NOT NULL,
  "status" varchar(15) default NULL,
  display varchar(300) default NULL,
  available varchar(100) default NULL,
  away varchar(100) default NULL,
  chat varchar(100) default NULL,
  dnd varchar(100) default NULL,
  unavailable varchar(100) default NULL,
  "xa" varchar(100) default NULL,
  PRIMARY KEY  (jid),
  UNIQUE KEY "hash" ("hash")
);
DROP TABLE IF EXISTS words;
CREATE TABLE words (
  plugin smallint(6) NOT NULL,
  "storage" smallint(6) NOT NULL,
  "name" varchar(50) NOT NULL,
  nick varchar(50) NOT NULL,
  "date" timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  "value" text NOT NULL,
  PRIMARY KEY  (plugin,"storage","name",nick)
);
