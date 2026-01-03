-- 02_create_tables.sql
-- Create tables for enterprise attendance system.
-- This is the author's first GitHub repository as a sophomore software engineering student.Suggestions and improvements are welcome.

-- Tables included:
-- 1. 部门
-- 2. 员工
-- 3. 系统设置
-- 4. 请假
-- 5. 考勤打卡
-- 6. 每日考勤
-- 7. 缺勤通报

--部门
CREATE TABLE 部门
(部门编号 int primary key,
 部门名称 nchar(30))
select*from 部门
--员工
CREATE TABLE 员工
(员工编号 int primary key,
 员工姓名 nchar(30),
 部门编号 int foreign key references 部门(部门编号))
select*from 员工
--系统设置
CREATE TABLE 系统设置
(设置编号 int,
 上班时间 time(0),
 下班时间 time(0),
 加班时间 time(0))
select*from 系统设置
