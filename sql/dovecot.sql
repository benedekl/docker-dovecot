#!/bin/sh
psql << E_O_SQL

CREATE ROLE mails WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  PASSWORD 'password'; -- Change me!

CREATE USER mailreader PASSWORD 'password-ro'; -- Change me!

CREATE DATABASE mails WITH 
  OWNER = mails
  ENCODING = 'UTF8'
  LC_COLLATE = 'en_US.UTF-8'
  LC_CTYPE = 'en_US.UTF-8'
  TABLESPACE = pg_default
  CONNECTION LIMIT = -1;

\c mails

CREATE TABLE transport (
  domain VARCHAR(128) NOT NULL,
  transport VARCHAR(128) NOT NULL,
  PRIMARY KEY (domain)
);

CREATE TABLE users (
  userid VARCHAR(128) NOT NULL,
  password VARCHAR(128),
  realname VARCHAR(128),
  uid INTEGER NOT NULL,
  gid INTEGER NOT NULL,
  home VARCHAR(128),
  mail VARCHAR(255),
  PRIMARY KEY (userid)
);

CREATE TABLE virtual (
  address VARCHAR(255) NOT NULL,
  userid VARCHAR(255) NOT NULL,
  PRIMARY KEY (address)
);

create view postfix_mailboxes as
  select userid, home||'/' as mailbox from users
  union all
  select domain as userid, 'dummy' as mailbox from transport;

create view postfix_virtual as
  select userid, userid as address from users
  union all
  select userid, address from virtual;

GRANT SELECT ON transport, users, virtual, postfix_mailboxes, postfix_virtual TO mailreader;

E_O_SQL