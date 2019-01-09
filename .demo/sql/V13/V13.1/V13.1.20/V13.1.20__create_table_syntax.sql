-- 创建表
create table if not exists create_table_syntax_demo1  (
	id INT unsigned NOT NULL auto_increment,
	username varchar(255) not null default '',
	age int unsigned not null default 0,
	constraint primary key (`id`)
);

show create table create_table_syntax_demo1;

insert into create_table_syntax_demo1
(username, age)
values
('test001', 12),
('test002', 28),
('test003', 22);

-- 临时表, 基于连接存在, 当连接关闭后, 自动删除
create temporary table create_table_syntax_demo1_tmp  (
	id INT unsigned NOT NULL auto_increment,
	username varchar(255) not null default '',
	age int unsigned not null default 0,
	constraint primary key (`id`)
);

-- 只克隆表结构, 不克隆数据
create table create_table_syntax_demo2 
like create_table_syntax_demo1;

-- 克隆表结构以及数据
create table create_table_syntax_demo3 
as select * from create_table_syntax_demo1;


