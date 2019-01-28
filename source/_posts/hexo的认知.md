---
title: hexo的认知
tags:
  - hexo
categories:
  - hexo
date: 2019-01-25 16:33:32
---

<hr>

### 预览：
1. 自定义文章模板
2. 加入 `<script>`
3. 加入全局样式
4. hexo 内置全局变量
5. 如何打印全局变量


#### 1. 自定义文章模板
> \themes\landscape\layout\_partial\after-footer.ejs

#### 2. 加入 `<script>`
> \scaffolds\post.md

#### 3. 加入全局样式
> \my\themes\landscape\source\css\style.styl

#### 4. hexo 内置全局变量
> [https://hexo.io/zh-cn/docs/variables](https://hexo.io/zh-cn/docs/variables)

#### 5. 如何打印全局变量
打开任意一个ejs文件如：`my\themes\landscape\layout\_partial\article.ejs`，顶部加入JavaScript代码：
```ejs
<% 
	console.log(20190125172431, post) 
%>
```
不过并不会打印到页面，而是打印到控制台。

![console.log](hexo的认知/1.png)

