---
title: Centos7 PHP-lastest 安装
date: 2019-01-25 09:13:58
tags:
- PHP
- centos
categories: 
- centos
- PHP
---

<hr>

参考官方 UNIX 编译教程： [http://php.net/manual/zh/install.unix.php](http://php.net/manual/zh/install.unix.php)

###### 1、安装依赖
```bash
$ sudo yum install libxml2 libxml2-devel
```
###### 2、下载php（China）: http://php.net/get/php-7.3.1.tar.gz/from/a/mirror
```bash
$ wget -O php-7.3.1.tar.gz http://cn2.php.net/get/php-7.3.1.tar.gz/from/this/mirror
```

###### 3、编译三兄贵
```bash
$ ./configure --disable-fileinfo --enable-fpm
$ make && make install 
```
<!--more--> 
加入--disable-fileinfo是为了避免make时出现如下错误：
> virtual memory exhausted: Cannot allocate memory 
> make: *** [ext/fileinfo/libmagic/apprentice.lo] Error 1

其中 `--enable-fpm` 是支持fpm扩展

安装完成之后，会出现如下提示语：

> Wrote PEAR system config file at: /usr/local/etc/pear.conf
> You may want to add: /usr/local/lib/php to your php.ini include_path
> /home/dc2-user/php-7.3.1/build/shtool install -c ext/phar/phar.phar /usr/local/bin
> ln -s -f phar.phar /usr/local/bin/phar
> Installing PDO headers:           /usr/local/include/php/ext/pdo/

请放心这是正常的，实际上此时你的php已经安装成功了：
```bash
$ php -v

PHP 7.3.1 (cli) (built: Jan 24 2019 21:37:18) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.3.1, Copyright (c) 1998-2018 Zend Technologies
```

###### 4、创建配置文件，并将其复制到正确的位置。
```bash
$ sudo cp php.ini-development /usr/local/php/php.ini
$ sudo cp /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.conf
$ sudo cp sapi/fpm/php-fpm /usr/local/bin
```

接下来你可能想要了解：
- [nginx 与 php 结合使用](/2019/01/25/Nginx与php结合/)
- nginx 与 apache 结合使用