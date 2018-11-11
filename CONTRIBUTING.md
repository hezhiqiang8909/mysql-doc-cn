# 如何贡献

## 如何贡献翻译

1. 查看issue, 避免和他人重复
2. 创建相关翻译的issue, 详见[如何创建issue](#如何创建issue)
3. 团队成员创建新分支, 非团队成员请fork仓库到自己的仓库
4. 翻译文档路径必须和源文档目录相同, **名字中带空格的使用`-`代替**, 
例如: 源文档为Language Structure/Literal Values, 
则翻译文档的路径位Language-Structure/Literal-Values.md
5. 在翻译文档的同时, 须同时提供相关的demo在**.demo目录下**, 
路径格式同翻译文档路径, 详见[如何创建demo](#如何创建demo)
6. 翻译文档中有涉及到demo的地方, 请添加demo路径
7. 提交Pull Request, 需要在comment里面写入`issues(#<issue_id>)`, 用于链接相关的issue
8. 经团队审核通过后, 会被合并到master分支; 否则会注明修改项, 打回修改.

## 如何创建issue

1. 挑选
2. 标题需要使用**源文档的标题**
3. 在issue内容中列出**源文档的URL**
4. issue会被定期查看, 如果查过**1个月**未有任何Pull Request, 则将会被关闭.
所以请尽量选择合适的文档体量

## 如何创建demo

1. 在**.demo目录**下根据翻译文档的路径创建demo的sql文件, 
如果有多个文件, 则创建目录, 根据demo内容创建sql文件