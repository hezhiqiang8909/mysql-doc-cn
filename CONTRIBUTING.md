# 如何贡献

## 如何贡献翻译

1. 查看issue, 避免和他人重复
2. 创建相关翻译的issue, 详见[如何创建issue](#如何创建issue)
3. 团队成员创建新分支, 非团队成员请fork仓库到自己的仓库
4. 翻译文档路径必须和源文档目录相同, **必须带上章节号, 格式: <章节号>-<源文档的标题>**, 
例如: 源文档为Language Structure/Literal Values, 
则翻译文档的路径位<章节号>-Language Structure/<章节号>-LiteralValues.md
5. 在翻译文档的同时, 须同时提供相关的demo在**.demo目录下**, 详见[如何创建demo](#如何创建demo)
6. 在翻译文档末尾, 添加原文路径以及demo路径
7. 提交Pull Request, 需要在comment里面写入`issues(#<issue_id>)`, 用于链接相关的issue
8. 经团队审核通过后, 会被合并到master分支; 否则会注明修改项, 打回修改.

## 如何创建issue

1. 挑选未被翻译或者已经翻译完成的文档, 可对已完成翻译的文档进一步修订
2. 标题需要使用**<章节号>-<源文档的标题>**
3. 在issue内容中列出**源文档的URL**
4. issue会被定期查看, 如果查过**1个月**未有任何Pull Request, 则将会被关闭.
所以请尽量选择合适的文档体量

## 如何创建demo

1. 在**.demo目录**下根据翻译文档的章节号创建demo的sql文件
2. 所有的sql文件需要遵循[flyway]()的要求, 能够被flyway执行, 
我们会通过pipeline使用mysql的docker镜像进行验证
3. 每篇源文件的demo对应一个flyway的sql, sql文件的命名为**V<源文件的章节号>__<源文档的标题, 空格使用`-`代替>.sql**
4. 每个demo需要创建**独立的数据库**, 数据库名同源文档的标题, 使用**小写**, 空格或特殊字符使用`_`代替, 
例如INSERT Syntax的数据库为insert_syntax
