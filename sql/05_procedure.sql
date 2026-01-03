-- 05_procedures.sql
-- Stored procedures for attendance statistics.
-- This is the author's first GitHub repository as a sophomore software engineering student.Suggestions and improvements are welcome.

CREATE PROCEDURE 统计员工月考勤
@年份 int,
@月份 int
as
begin
    select m.员工编号,
           isnull(q1.缺勤次数,0)as 缺勤次数,
           isnull(q2.旷工次数,0)as 旷工次数,
           isnull(q3.迟到次数,0)as 迟到次数,
           isnull(q4.早退次数,0)as 早退次数
    from(select distinct 员工编号
         from 每日考勤
         where year(考勤日期) = @年份
         and month(考勤日期) = @月份)m
    left join(select 员工编号,count(*) as 缺勤次数
              from 每日考勤
              where 上班判定 = '缺勤'
              and year(考勤日期) = @年份
              and month(考勤日期) = @月份
              group by 员工编号)q1
    on m.员工编号 = q1.员工编号
    left join(select 员工编号,count(*) as 旷工次数
              from 每日考勤
              where 上班判定 = '旷工'
              and year(考勤日期) = @年份
              and month(考勤日期) = @月份
              group by 员工编号)q2
    on m.员工编号 = q2.员工编号
    left join(select 员工编号,count(*) as 迟到次数
              from 每日考勤
              where 上班判定 = '迟到'
              and year(考勤日期) = @年份
              and month(考勤日期) = @月份
              group by 员工编号)q3
    on m.员工编号 = q3.员工编号
    left join(select 员工编号,count(*) as 早退次数
              from 每日考勤
              where 是否早退 = '是'
              and year(考勤日期) = @年份
              and month(考勤日期) = @月份
              group by 员工编号)q4
    on m.员工编号 = q4.员工编号
end

CREATE PROCEDURE 部门每周考勤汇总
@开始日期 DATE,
@结束日期 DATE
as
begin
    select t.部门名称,
           isnull(q1.迟到次数,0) as 迟到次数,
           isnull(q2.缺勤次数,0) as 缺勤次数,
           isnull(q3.旷工次数,0) as 旷工次数,
           isnull(q4.早退次数,0) as 早退次数,
           isnull(q5.加班人数,0) as 加班人数,
           isnull(q6.加班总分钟,0) as 加班总分钟
    from(select distinct b.部门名称
         from 每日考勤 m
         inner join 员工 y
         on m.员工编号 = y.员工编号
         inner join 部门 b
         on y.部门编号 = b.部门编号
         where m.考勤日期 between @开始日期 and @结束日期)t
    left join(select b.部门名称,count(*) as 迟到次数
              from 每日考勤 m
              inner join 员工 y
              on m.员工编号 = y.员工编号
              inner join 部门 b
              on y.部门编号 = b.部门编号
              where m.考勤日期 between @开始日期 and @结束日期
              and m.上班判定 = '迟到'
              group by b.部门名称)q1
    on t.部门名称 = q1.部门名称
    left join(select b.部门名称,count(*) as 缺勤次数
              from 每日考勤 m
              inner join 员工 y
              on m.员工编号 = y.员工编号
              inner join 部门 b
              on y.部门编号 = b.部门编号
              where m.考勤日期 between @开始日期 and @结束日期
              and m.上班判定 = '缺勤'
              group by b.部门名称)q2
    on t.部门名称 = q2.部门名称
    left join(select b.部门名称,count(*) as 旷工次数
              from 每日考勤 m
              inner join 员工 y
              on m.员工编号 = y.员工编号
              inner join 部门 b
              on y.部门编号 = b.部门编号
              where m.考勤日期 between @开始日期 and @结束日期
              and m.上班判定 ='旷工'
              group by b.部门名称)q3
    on t.部门名称 = q3.部门名称
    left join(select b.部门名称,count(*) as 早退次数
              from 每日考勤 m
              inner join 员工 y
              on m.员工编号 = y.员工编号
              inner join 部门 b
              on y.部门编号 = b.部门编号
              where m.考勤日期 between @开始日期 and @结束日期
              and m.是否早退 ='是'
              group by b.部门名称)q4
    on t.部门名称 = q4.部门名称
    left join(select b.部门名称,count(distinct y.员工编号) as 加班人数
              from 每日考勤 m
              inner join 员工 y
              on m.员工编号 = y.员工编号
              inner join 部门 b
              on y.部门编号 = b.部门编号
              where m.考勤日期 between @开始日期 and @结束日期
              and m.加班分钟 >0
              group by b.部门名称)q5
    on t.部门名称 = q5.部门名称
    left join(select b.部门名称,sum(m.加班分钟) as 加班总分钟
              from 每日考勤 m
              inner join 员工 y
              on m.员工编号 = y.员工编号
              inner join 部门 b
              on y.部门编号 = b.部门编号
              where m.考勤日期 between @开始日期 and @结束日期
              group by b.部门名称)q6
    on t.部门名称 =q6.部门名称
end

CREATE PROCEDURE 部门每月考勤汇总
@年份 int,
@月份 int
AS
BEGIN
    select t.部门名称,
           isnull(q1.迟到次数,0) as 迟到次数,
           isnull(q2.缺勤次数,0) as 缺勤次数,
           isnull(q3.旷工次数,0) as 旷工次数,
           isnull(q5.加班人数,0) as 加班人数,
           isnull(q6.加班总分钟,0) as 加班总分钟
    from(select distinct b.部门名称
         from 每日考勤 m
         inner join 员工 y
         on m.员工编号 = y.员工编号
         inner join 部门 b
         on y.部门编号 = b.部门编号
         where year(m.考勤日期) = @年份
         and month(m.考勤日期) = @月份)t
    left join(select b.部门名称,count(*) as 迟到次数
              from 每日考勤 m
              inner join 员工 y
              on m.员工编号 = y.员工编号
              inner join 部门 b
              on y.部门编号 = b.部门编号
              where year(m.考勤日期)=@年份
              and month(m.考勤日期)=@月份
              and m.上班判定='迟到'
              group by b.部门名称)q1
    on t.部门名称=q1.部门名称
    left join(select b.部门名称, count(*) as 缺勤次数
              from 每日考勤 m
              inner join 员工 y
              on m.员工编号 = y.员工编号
              inner join 部门 b
              on y.部门编号 = b.部门编号
              where year(m.考勤日期)=@年份
              and month(m.考勤日期)=@月份
              and m.上班判定='缺勤'
              group by b.部门名称)q2
    on t.部门名称=q2.部门名称
    left join(select b.部门名称, count(*) as 旷工次数
              from 每日考勤 m
              inner join 员工 y on m.员工编号 = y.员工编号
              inner join 部门 b on y.部门编号 = b.部门编号
              where year(m.考勤日期)=@年份
              and month(m.考勤日期)=@月份
              and m.上班判定='旷工'
              group by b.部门名称)q3
    on t.部门名称=q3.部门名称
    left join(select b.部门名称, count(distinct y.员工编号) as 加班人数
              from 每日考勤 m
              inner join 员工 y on m.员工编号 = y.员工编号
              inner join 部门 b on y.部门编号 = b.部门编号
              where year(m.考勤日期)=@年份
              and month(m.考勤日期)=@月份
              and m.加班分钟>0
              group by b.部门名称)q5
    on t.部门名称=q5.部门名称
    left join(select b.部门名称, sum(m.加班分钟) as 加班总分钟
              from 每日考勤 m
              inner join 员工 y on m.员工编号 = y.员工编号
              inner join 部门 b on y.部门编号 = b.部门编号
              where year(m.考勤日期)=@年份
              and month(m.考勤日期)=@月份
              group by b.部门名称)q6
    on t.部门名称=q6.部门名称;
END
