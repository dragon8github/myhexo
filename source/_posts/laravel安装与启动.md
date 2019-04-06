---
title: laravel 安装与启动
date: 2019-01-19 20:51:42
tag:
- laravel
- php
categories:
- php
- laravel
---

## 1、使用 composer 安装 laravel

[https://packagist.org/packages/laravel/laravel](https://packagist.org/packages/laravel/laravel)

```bash
$ composer create-project laravel/laravel laravel5
```

&#8195;&#8195;

## 2、启动 laravel

##### 方式一：php 内置服务器

指定 public 文件夹即可

```bash
$ php -S localhost:8000 -t public
```

##### 方式二：使用laravel提供的命令行工具artisan

```bash
$ php artisan serve
```
<!--more--> 
![](laravel-start/2.png)

预览 [http://localhost:8000](http://localhost:8000) ，效果如下：

![](laravel-start/1.png)