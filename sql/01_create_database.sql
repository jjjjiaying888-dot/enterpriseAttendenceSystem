--01_create_database.sql
--create database for enterprise attendance system
--ps:If your computer dose not hava D:\,change the 'filename'.
--This is the author's first GitHub repository as a sophomore software engineering student.Suggestions and improvements are welcome.
CREATE DATABASE 测试
on primary
(name = '测试_data',
 filename = 'D:\测试_data.mdf',
 size = 10MB,
 maxsize = unlimited,
 filegrowth = 2MB)
log on
(name = '测试_log',
 filename = 'D:\测试_log.ldf',
 size = 10MB,
 maxsize = unlimited,
 filegrowth = 25%)
--After building the database,run this statement to use the database.
use 测试
