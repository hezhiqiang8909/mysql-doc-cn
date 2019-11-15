# 15.7.2 InnoDB Transaction Model

在InnoDB事务模型中，目标是将**多版本数据库(multi-versioning database)**的最佳属性与传统的**两阶段锁定(two-phase locking)**相结合。
InnoDB默认以Oracle风格在**行级别执行锁定**，并以**非阻塞一致性读**的形式运行查询。
InnoDB中的锁信息以节省空间的方式存储，因此不需要锁升级。
通常，允许多个用户锁定InnoDB表中的每一行或行的任何随机子集，而不会导致InnoDB内存耗尽。
