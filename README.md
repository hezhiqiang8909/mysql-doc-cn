# MySQL 8 中文文档

[MySQL 8中文文档 Gitbook](https://s2u2m.gitbook.io/mysql-8-doc-cn)

translate [mysql 8.0](https://dev.mysql.com/doc/refman/8.0/en/) to Chinese

## 目录

- [ ] [Chaper 9 Language Structure](https://dev.mysql.com/doc/refman/8.0/en/language-structure.html)
- [ ] [Chaper 10 Character Sets, Collations, Unicode](https://dev.mysql.com/doc/refman/8.0/en/charset.html)
- [ ] [Chapter 11 Data Types](https://dev.mysql.com/doc/refman/8.0/en/data-types.html)
- [ ] [Chapter 12 Functions and Operators](https://dev.mysql.com/doc/refman/8.0/en/functions.html)
- [ ] [Chaper 13 SQL Statement Syntax](https://dev.mysql.com/doc/refman/8.0/en/sql-syntax.html)

## 运行demo

安装docker-compose, 详情见: [Install Docker Compose](https://docs.docker.com/compose/install/)

在根目录下运行docker-compose来创建mysql服务以及相关的数据库

```
$ docker-compose up -V
```

下载flyway, 详见: [Download and installation](https://flywaydb.org/documentation/commandline/#download-and-installation)

将flyway加入到PATH中, 运行flyway来执行用例.

执行所有用例
```
$ cd .demo
$ flyway migrate
```

执行指定章节的用例
```
$ cd .demo
$ flyway -locations=filesystem:./sql/V13.2.6 migrate
```
