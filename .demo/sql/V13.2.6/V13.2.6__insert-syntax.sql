-- 准备表和数据
create table insert_syntax_tb1 (
  id int unsigned not null primary key auto_increment,
  user_name varchar(255) not null,
  sex tinyint not null default 0,
  age int unsigned not null,
  born_time datetime not null default now(),
  dead_time datetime null, 

  unique key `UK_insert_syntax_demo_user_name` (`user_name`(32) asc)
) engine=InnoDB;

-- 用例演示

-- insert基本使用
insert into insert_syntax_tb1
(`user_name`, `sex`, `age`, `born_time`, `dead_time`)
values
('test1', 0, 18, now(), null);

insert into insert_syntax_tb1
set `user_name`='test2',
  `sex`=1,
  `age`=10, 
  `born_time`=now(), 
  `dead_time`=null;

insert into insert_syntax_tb1
(`user_name`, `sex`, `age`, `born_time`, `dead_time`)
select 'test3', `sex`, `age`, `born_time`, `dead_time`
from insert_syntax_tb1
where `id`=1;

-- ON DUPLICATE KEY
insert into insert_syntax_tb1
(`user_name`, `sex`, `age`, `born_time`, `dead_time`)
values
('test1', 0, 18, now(), null)
ON DUPLICATE KEY 
update `age` = 20;

-- `sex`使用默认值
insert into insert_syntax_tb1
(`user_name`, `age`, `born_time`, `dead_time`)
values
('test4', 30, now(), null);

-- 类型转换
insert into insert_syntax_tb1
(`user_name`, `age`, `born_time`, `dead_time`)
values
('test5', '1999.0e-2', now(), null);

-- 插入时使用`AUTO_INCREMENT`列`id`的值进行计算, 计算时`id`为0
-- `AUTO_INCREMENT`列的值总是在最后进行计算
insert into insert_syntax_tb1
(`user_name`, `age`, `born_time`, `dead_time`)
values
('test6', `id`*4, now(), null);

-- 多行插入
insert into insert_syntax_tb1
(`user_name`, `sex`, `age`, `born_time`, `dead_time`)
values
('test7', 0, 18, now(), null),
('test8', 1, 18, now(), null),
('test9', 1, 18, now(), null),
('test10', 0, 18, now(), null);

-- affected-row的值
-- 新行为1
insert into insert_syntax_tb1
(`user_name`, `sex`, `age`, `born_time`, `dead_time`)
values
('test11', 0, 18, now(), null);

-- 更新已有行为2
insert into insert_syntax_tb1
(`user_name`, `sex`, `age`, `born_time`, `dead_time`)
values
('test11', 0, 18, now(), null)
ON DUPLICATE KEY update `age`=20;

-- 插入时, 不更新重复行为0
insert into insert_syntax_tb1
(`user_name`, `sex`, `age`, `born_time`, `dead_time`)
values
('test11', 0, 18, now(), null)
ON DUPLICATE KEY update `sex`=0;