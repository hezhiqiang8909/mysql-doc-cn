# 13.2.6 INSERT Syntax

[原文](https://dev.mysql.com/doc/refman/8.0/en/insert.html)

## 语法

```
INSERT [LOW_PRIORITY | DELAYED | HIGH_PRIORITY] [IGNORE]
    [INTO] tbl_name
    [PARTITION (partition_name [, partition_name] ...)]
    [(col_name [, col_name] ...)]
    {VALUES | VALUE} (value_list) [, (value_list)] ...
    [ON DUPLICATE KEY UPDATE assignment_list]

INSERT [LOW_PRIORITY | DELAYED | HIGH_PRIORITY] [IGNORE]
    [INTO] tbl_name
    [PARTITION (partition_name [, partition_name] ...)]
    SET assignment_list
    [ON DUPLICATE KEY UPDATE assignment_list]

INSERT [LOW_PRIORITY | HIGH_PRIORITY] [IGNORE]
    [INTO] tbl_name
    [PARTITION (partition_name [, partition_name] ...)]
    [(col_name [, col_name] ...)]
    SELECT ...
    [ON DUPLICATE KEY UPDATE assignment_list]

value:
    {expr | DEFAULT}

value_list:
    value [, value] ...

assignment:
    col_name = value

assignment_list:
    assignment [, assignment] ...
```

## 基本使用

`INSERT`向一个已存在的表中插入新的行数据.
`INSERT ... VALUES`和`INSERT ... SET`用于插入特定值的行数据;
`INSERT ... SELECT`则用于将从指定表查询到的结果集插入到表中.

## ON DUPLICATE KEY

`INSERT`中使用`ON DUPLICATE KEY UPDATE`时, 会检查`UNIQUE KEY`和`PRIMARY KEY`是否存在重复的行数据, 
如果存在, 则更新行数据, 否则插入新的行数据.

插入行数据到表需要以下权限:

- (必须)INSERT权限
- 当使用`ON DUPLICATE KEY UPDATE`时, 需要UPDATE权限
- 当使用`SELECT`查询语句或读取列属性时, 需要SELECT权限

当插入行数据到分表中时, 可以指定哪些分表可以用来添加新增的行数据, 这些分表使用**,**隔开.
当行数据无法添加到这些指定的分表时, 会提示错误**Found a row not matching the given partition set**.
分表相关内容详见[Partition Selection](https://dev.mysql.com/doc/refman/8.0/en/partitioning-selection.html)

当插入的行数据可以**重写**老的行数据时, 可以使用`REPLACE`来代替`INSERT`.
`REPLACE`和`INSERT IGNORE`相反的, 当老的行数据和新的行数据的`UNIQUE KEY`相同时, 新的行数据会覆盖老的行数据, 而不是放弃插入.
详见[REPLACE Syntax](https://dev.mysql.com/doc/refman/8.0/en/replace.html)

**tbl_name**指明行数据将被插入到哪个表中.

**col_name**列表中的列名必须用`,`分割, 用来指明来源于`VALUES`或者`SELECT`查询结果集的行数据必须包含哪些数据.
如果不指明列名列表, 则插入的行数据必须提供表定义中所有列的值. 可以通过`DESCRIBE`(缩写`desc`) **tbl_name**得到表定义.
**SET**条件需要显示提供列名和值, 格式为`col_name=col_value`

列值的来源可以有以下几种方式:

- 如果**strict SQL mode**没有开启, 任何没有显示声明的列会使用默认值作为列值.
默认值详见[Data Type Default Values](https://dev.mysql.com/doc/refman/8.0/en/data-type-defaults.html)
和[Constraints on Invalid Data](https://dev.mysql.com/doc/refman/8.0/en/constraint-invalid-data.html)
- 如果列名和列值都没有提供, 则INSERT操作会为每一列插入它的默认值(在表定义时必须提供默认值, 否则会报错):
`INSERT INTO tbl_name () VALUES();`.
如果`strict mode`没有开启, MySQL会将隐式默认值赋予没有显式声明的列; 否则提示`没有默认值`的错误.
- 使用`DEFAULT`为指定列显示声明默认值. 它为`INSERT`语句提供便利, 保证在插入时为所有列都能提供有效值, 
避免某些值遗漏. 如果不使用`DEFAULT`, 则必须在INSERT时显式为每一列提供有效值.
- `generated column`的值只允许使用`DEFAULT`值, 详情见[CREATE TABLE and Generated Columns]()
- 可以在表达式中使用`DEFAULT`来为column生成默认值.
- 如果表达式的值和column的类型不匹配时, 会发生类型转换, 转换的结果取决与column的类型. 
例如, 将字符串'1999.0e-2'插入到INT, FLOAT, DECIMAL(10,6) 或者YEAR的column, 
它的值分别为1999, 19.9921, 19.992100, or 1999.
INT和YEAR的column的值都是1999, 
因为string-to-number的转换只会发生在字符串从首字符开始最多能被辨认出来的有效的数字或者年.
对于FLOAT和DECIMAL的column, string-to-number的转换会检查整个string是否为一个有效的数字.
- column的表达式可以使用任意已经定义了的column的值. 例如: 
`INSERT INTO tbl_name (col1,col2) VALUES(15,col1*2);`
可以根据col1为col2赋值, 因为col1在col2之前已经赋值了.
又比如: 
`INSERT INTO tbl_name (col1,col2) VALUES(col2*2,15);`
这个是错误的, 因为col1根据col2来赋值, 但是col2在col1之后才赋值的.
- `AUTO_INCREMENT`列的值总是在最后才会被赋值, 即在所有其他列赋值之后.
如果任何列基于`AUTO_INCREMENT`列的值进行计算, 则对应的`AUTO_INCREMENT`列的值为0.

## 多行插入

`INSERT`语句可以使用`VALUES`来插入**多行**, 通过**逗号**分隔多行的列值. 例如: 
`INSERT INTO tbl_name (a,b,c) VALUES(1,2,3),(4,5,6),(7,8,9);`

每一行的列值必须和`INSERT`语句显式声明要插入的列一一对应. 
以下是一个错误的例子, 显式声明要插入的列有3个, 但插入了9个列值. 
`INSERT INTO tbl_name (a,b,c) VALUES(1,2,3,4,5,6,7,8,9);`

在`INSERT`语句的上下文中, `VALUE`和`VALUES`是同义词, 没有任何区别.

被`INSERT`接受的行可以通过SQL function`ROW_COUNT()`或者C API function`mysql_affected_rows()`来获取.
详见[Information Functions](https://dev.mysql.com/doc/refman/8.0/en/information-functions.html)
和[mysql_affected_rows()](https://dev.mysql.com/doc/refman/8.0/en/mysql-affected-rows.html)

### 多行插入的的响应信息

如果使用`INSERT ... VALUES`或者`INSERT ... SELECT`来插入多行, 会返回以下的信息.
`Records: N1 Duplicates: N2 Warnings: N3`

也可以通过使用C API `mysql_info()`来获取这些信息. 详见[mysql_info()](https://dev.mysql.com/doc/refman/8.0/en/mysql-info.html)

- `Records`, 有多少行被该语句处理(它不是真正被插入到表中的数量, 因为`Duplicates`有可能非零)
- `Duplicates`, 有多少行由于存在unique index的值重复, 导致没有被插入
- `Warnings`, 有多少行存在问题而无法被插入

`Warnings`可能会发生的场景:

- 将NULL插入到NOT NULL的列. 针对多行插入语句, 会隐式的使用列类型的默认值进行赋值. 
即数值类型为0, 字符串为空字符'', 时间类型为'0'. 
而针对单行插入, 则会直接报错.
- 如果给数值类型的类赋予一个超出范围的值, 则会发生截取, 截取的值为最靠近类型范围的值.
- 将字符串'10.34 a'赋给一个数值类型的列, 则小数点后将被删除, 只将剩余部分'10'插入.
如果没有小数点前没有任何数字部分, 则使用数值类型的默认值0.
- 将一个超长的字符串插入到字符串类型(CHAR, VARCHAR, TEXT, BLOB)的列, 
它的值会被缩短, 只保留最大长度的部分.
- 如果将一个非法的值插入到时间类型(date, time)的列, 则会使用0来填充列值.
- 插入语句如果涉及到`AUTO_INCREMENT`列的值, 请参考[Using AUTO_INCREMENT](https://dev.mysql.com/doc/refman/8.0/en/example-auto-increment.html)
如果插入一行到一个有`AUTO_INCREMENT`列的表, 可以通过SQL function `LAST_INSERT_ID()`或者C API `mysql_insert_id()`来获取对应的值.

**注意**: LAST_INSERT_ID和mysql_insert_id返回的值不一定总是相等.
有关`INSERT`中涉及`AUTO_INCREMENT`会在后面再深入学习, 
详见[12.15 Information Functions](https://dev.mysql.com/doc/refman/8.0/en/information-functions.html)
和[28.7.7.38 mysql_insert_id()](https://dev.mysql.com/doc/refman/8.0/en/mysql-insert-id.html)

## INSERT的修饰符

`INSERT`语句支持以下几种修饰符:

### LOW_PRIORITY

如果使用`LOW_PRIORITY`修饰符, `INSERT`操作会被执行直到没有任何其他连接正在读取这张表. 
这些连接包括准备开始读的, 已经正在读的和其他等待中的`INSERTLOW_PRIORITY`语句.
所以`INSERT LOW_PRIORITY`语句可能会需要等待很长一段时间后才会执行.

`LOW_PRIORITY`只适用于**表级锁**的存储引擎, 例如MyISAM, MEMORY, and MERGE.

**Note**: `LOW_PRIORITY`通常不用于MyISAM类型的表, 因为会导致并发插入失效, 详见[8.11.3 Concurrent Inserts][]

### HIGH_PRIORITY

如果使用了`HIGH_PRIORITY`, 它会覆盖`--low-priority-updates`设置的效果, 如果MySQL服务器启动时设置了该参数.
它也会导致并发插入失效, 详见[8.11.3 Concurrent Inserts][].

`HIGH_PRIORITY`只适用于HIGH_PRIORITY的存储引擎, 例如MyISAM, MEMORY, and MERGE.

### IGNORE

如果使用`IGNORE`修饰符, 执行INSERT时发生的错误会被忽略. 
例如在不使用`IGNORE`时插入一条重复的行, 会导致**duplicate-key**的错误并且执行语句会被中断.
如果使用了`IGNORE`, 插入的重复的行会被丢弃并且没有任何错误产生, 而是使用**警告**代替.

对于插入行到多个分表的操作, `IGNORE`也有相同的效果. 不使用`IGNORE`时, 插入操作会因为报错而中断.
而当使用`IGNORE`时, 没有匹配的行将会被丢弃而不会报错, 而其他匹配的行会被插入. 例子见[23.2.2 LIST Partitioning][]

如果`IGNORE`没有被使用, 数据类型转换失败的话会导致语句执行中断.
如果使用了`IGNORE`, 则不匹配的值会被调整为尽量接近类型范围的值, 然后插入语句会被执行, 但是会产生警告.
可以通过`mysql_info()` C API函数查看实际有多少行真正被插入到表中. 
详见[Comparison of the IGNORE Keyword and Strict SQL Mode][]

### ON DUPLICATE KEY UPDATE

如果使用了`ON DUPLICATE KEY UPDATE`并且插入的行导致了UNIQUE index或者PRIMARY KEY重复, 
那么引发对表中已存在的重复行的`UPDATE`操作.

**affected-rows的值**

- 1, 如果插入一条新行; 
- 2, 如果和已有行重复并设置为不同的值; 
- 0, 如果和已有行重复并不修改已有行的值, 即设置为已有行的值

当连接mysqld时, 将`CLIENT_FOUND_ROWS`标志设置给`mysql_real_connect()`C API函数,
affected-rows的值为1(而不是0), 如果和已有行重复并不修改已有行的值, 即设置为已有行的值.
详见[13.2.6.2 INSERT ... ON DUPLICATE KEY UPDATE Syntax][]

### DELAYED

从MySQL 5.6开始, `DELAYED`已经被废弃并计划永远移除掉.
在MySQL 8.0中, `DELAYED`可以被使用但没有任何效果, 执行时会被忽略掉.
详见[13.2.6.3 INSERT DELAYED Syntax][].

插入行数据到使用MyISAM存储引擎的分表中时会使用**表级锁**, 将那些将要插入行数据的分表锁住.
而针对使用InnoDB的分表, 则会使用**行级锁**, 而不会将整个分表锁住.
详见[22.6.4 Partitioning and Locking][]

---

[CREATE TABLE and Generated Columns]: https://dev.mysql.com/doc/refman/8.0/en/create-table-generated-columns.html
[8.11.3 Concurrent Inserts]: https://dev.mysql.com/doc/refman/8.0/en/concurrent-inserts.html
[23.2.2 LIST Partitioning]: https://dev.mysql.com/doc/refman/8.0/en/partitioning-list.html
[Comparison of the IGNORE Keyword and Strict SQL Mode]: https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html#ignore-strict-comparison
[13.2.6.2 INSERT ... ON DUPLICATE KEY UPDATE Syntax]: https://dev.mysql.com/doc/refman/8.0/en/insert-on-duplicate.html
[13.2.6.3 INSERT DELAYED Syntax]: https://dev.mysql.com/doc/refman/8.0/en/insert-delayed.html
[22.6.4 Partitioning and Locking]: https://dev.mysql.com/doc/refman/5.7/en/partitioning-limitations-locking.html
