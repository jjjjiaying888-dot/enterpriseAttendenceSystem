-- 04_triggers.sql
-- Triggers for enterprise attendance system
-- This is the author's first GitHub repository as a sophomore software engineering student.Suggestions and improvements are welcome.

CREATE TRIGGER 考勤打卡_删除同步
on 考勤打卡
after delete
as
begin
    delete q
    from 缺勤通报 q
    inner join deleted d
    on q.员工编号 = d.员工编号
    and q.考勤日期 = d.考勤日期
    delete m
    from 每日考勤 m
    inner join deleted d
    on m.员工编号 = d.员工编号
    and m.考勤日期 = d.考勤日期
end

CREATE TRIGGER 员工_删除级联
ON 员工
instead of delete
as
begin
    delete qq
    from 缺勤通报 qq
    inner join deleted d
    on qq.员工编号 = d.员工编号
    delete m
    from 每日考勤 m
    inner join deleted d
    on m.员工编号 = d.员工编号;
    delete k
    from 考勤打卡 k
    inner join deleted d
    on k.员工编号 = d.员工编号;
    delete q
    from 请假 q
    inner join deleted d
    on q.员工编号 = d.员工编号;
    delete y
    from 员工 y
    inner join deleted d
    on y.员工编号 = d.员工编号;
end

CREATE TRIGGER 考勤_打卡
on 考勤打卡
after insert,update
as
begin
    declare @上班 time(0)
    declare @下班 time(0)
    declare @加班 time(0)
    select @上班 = 上班时间,@下班 = 下班时间,@加班 = 加班时间
    from 系统设置
    where 设置编号 = 1
    INSERT INTO 每日考勤(员工编号,考勤日期,上班判定,是否早退,加班分钟,上班打卡,下班打卡)
    SELECT i.员工编号,i.考勤日期,'正常','否',0,null,null
    from inserted i
    where not exists(select*from 每日考勤 m
                     where m.员工编号 = i.员工编号
                     and m.考勤日期 = i.考勤日期)
    update m
    set 上班打卡 = k.打卡时间
    from 每日考勤 m
    inner join 考勤打卡 k
    on m.员工编号 = k.员工编号
    and m.考勤日期 = k.考勤日期
    and k.打卡类型 = '上班'
    update m
    set 下班打卡 = k.打卡时间
    from 每日考勤 m
    inner join 考勤打卡 k
    on m.员工编号 = k.员工编号
    and m.考勤日期 = k.考勤日期
    and k.打卡类型 = '下班'
    update m
    set
    上班判定 = 
    case
        when exists(select *from 请假 q
                    where q.员工编号 = m.员工编号
                    and q.状态 = '已批准'
                    and m.考勤日期 between q.开始日期 and q.结束日期)
        then '请假'
        when m.上班打卡 is null
        then '缺勤'
        when m.上班打卡>@上班
        and datediff(minute,@上班,m.上班打卡)<60
        then '迟到'
        when m.上班打卡>@上班
        and datediff(minute,@上班,m.上班打卡)>=60
        then '旷工'
        else '正常'
    end,
    是否早退 = 
    case
        when exists(select*from 请假 q
                    where q.员工编号 = m.员工编号
                    and q.状态 = '已批准'
                    and m.考勤日期 between q.开始日期 and q.结束日期)
        then '否'
        when m.下班打卡 is not null
        and m.下班打卡<@下班
        then '是'
        else '否'
    end,
    加班分钟 = 
    case
        when exists(select*from 请假 q
                    where q.员工编号 = m.员工编号
                    and q.状态 = '已批准'
                    and m.考勤日期 between q.开始日期 and q.结束日期)
        then 0
        when m.下班打卡 is not null
        and m.下班打卡>@加班
        then datediff(minute,@加班,m.下班打卡)
        else 0
    end
    from 每日考勤 m
    inner join inserted i
    on m.员工编号 = i.员工编号
    and m.考勤日期 = i.考勤日期
end

CREATE TRIGGER 缺勤_旷工
on 每日考勤
after insert,update
as
begin
    insert into 缺勤通报
    select i.员工编号,i.考勤日期,i.上班判定
    from inserted i
    where i.上班判定 in('缺勤','旷工')
    and not exists (select*from 缺勤通报 q
                    where q.员工编号 = i.员工编号
                    and q.考勤日期 = i.考勤日期
                    and q.通报原因 = i.上班判定)
end
