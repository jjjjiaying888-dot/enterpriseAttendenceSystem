-- 07_demo_queries.sql
-- Demo queries to verify triggers, procedures and views.

-- View raw clock-in and clock-out records
SELECT * FROM 考勤打卡
  
-- View automatically generated daily attendance records (maintained by triggers)
SELECT * FROM 每日考勤

-- View automatically generated absence and absenteeism notifications (maintained by triggers)
SELECT * FROM 缺勤通报

-- Monthly attendance statistics per employee
EXEC 统计员工月考勤 2025, 12

-- Weekly attendance summary per department
EXEC 部门每周考勤汇总 '2025-12-23', '2025-12-29'

-- Monthly attendance summary per department
EXEC 部门每月考勤汇总 2025, 12

-- View: department overtime statistics
SELECT * FROM 部门加班统计
