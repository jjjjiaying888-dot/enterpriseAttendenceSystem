--06_views.sql
--Views for enterprise attendance system.
--This is the author's first GitHub repository as a sophomore software engineering student.Suggestions and improvements are welcome.

CREATE view 部门加班统计
as
select b.部门名称,count(distinct y.员工编号) as 加班人数,sum(m.加班分钟) as 加班总分钟
from 每日考勤 m
inner join 员工 y
on m.员工编号 = y.员工编号
inner join 部门 b
on y.部门编号 = b.部门编号
where m.加班分钟 >0
group by b.部门名称
