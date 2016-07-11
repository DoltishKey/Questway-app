CREATE TABLE qw_users(
id int auto_increment primary key,
password text NOT NULL,
autho_level int DEFAULT 1,
mail varchar(50) NOT NULL,
firstname varchar(50),
lastname varchar(50));



CREATE TABLE qw_employers(
id int primary key,
phone varchar(50),
link text,
company_name varchar(50),
url_logo varchar(50),
url_cover varchar(50),
about text,
CONSTRAINT one_to_one_user FOREIGN KEY (id) REFERENCES qw_users (id)
ON DELETE CASCADE);



CREATE TABLE qw_main_type(
id int auto_increment primary key,
name varchar(100));



CREATE TABLE qw_ads(
id int auto_increment primary key,
creator_id int,
main_type int,
title varchar(100),
main_info text,
creatriondate datetime,
display BOOLEAN,
link text,
company_name varchar(50),
url_logo varchar(50),
url_cover varchar(50),
about text,
CONSTRAINT ad_to_employer FOREIGN KEY (creator_id) REFERENCES qw_users (id)
ON DELETE CASCADE,
FOREIGN KEY (main_type) REFERENCES qw_main_type (id));



CREATE TABLE qw_spec_tags(
name varchar(100) primary key);



CREATE TABLE qw_spec_types(
ad_id int,
spec_tag varchar(100),
PRIMARY KEY(ad_id, spec_tag),
CONSTRAINT tag_to_ad FOREIGN KEY (ad_id) REFERENCES qw_ads (id)
ON DELETE CASCADE,
CONSTRAINT tag_to_type FOREIGN KEY (spec_tag) REFERENCES qw_spec_tags (name)
ON DELETE CASCADE);



CREATE TABLE qw_application(
id int auto_increment primary key,
ad_id int,
application_text text,
CONSTRAINT application_to_ad FOREIGN KEY (ad_id) REFERENCES qw_ads (id)
ON DELETE CASCADE);



CREATE TABLE qw_person(
application_id int,
name varchar(100),
mail varchar(50),
phone varchar(50),
CONSTRAINT person_to_application FOREIGN KEY (application_id) REFERENCES qw_application (id)
ON DELETE CASCADE);



CREATE TABLE qw_filter(
id int auto_increment primary key,
ad_id int,
name varchar(50),
color varchar(50),
CONSTRAINT filter_to_ad FOREIGN KEY (ad_id) REFERENCES qw_ads (id)
ON DELETE CASCADE);



CREATE TABLE qw_get_filter(
filter_id int,
application_id int,
got_it BOOLEAN,
PRIMARY KEY(filter_id, application_id),
CONSTRAINT filter_to_filter FOREIGN KEY (filter_id) REFERENCES qw_filter (id)
ON DELETE CASCADE,
CONSTRAINT filter_to_application FOREIGN KEY (application_id) REFERENCES qw_application (id)
ON DELETE CASCADE);
