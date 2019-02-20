---
title: 在 Windows 上搭建 Flutter 开发环境
tags:
  - flutter
categories:
  - flutter
date: 2019-02-20 16:08:58
---

<hr>
1、获取Flutter SDK：https://flutter.io/sdk-archive/#windows

2、解压 **flutter_windows_v1.0.0-stable.zip**，并将 flutter/bin 加入到环境变量

3、安装Android Studio ：https://developer.android.google.cn

4、在 Android Studio 的 **Browse repositories** 安装 **Flutter** 和 **Dart** 插件
- Flutter插件： 支持Flutter开发工作流 (运行、调试、热重载等)。
- Dart插件： 提供代码分析 (输入代码时进行验证、代码补全等)。

欢迎页 -> configure -> Plugins -> Browse repositories... -> Search

![configure](http://wx4.sinaimg.cn/large/006ar8zggy1g0cy57wy3qj30mr0ng3zw.jpg)

![Plugins](http://wx4.sinaimg.cn/large/006ar8zggy1g0cy5amfb5j30ru0nttac.jpg)

![Browse repositories...](http://wx4.sinaimg.cn/large/006ar8zggy1g0cy5d3o4xj30so0o20v9.jpg)

5、安装完 flutter 插件后，重启一下Android Studio，然后我们就可以新建 flutter 模板了。

欢迎页 -> Start a new Flutter project -> Flutter application -> 输入项目名称和选择flutter的sdk目录 -> finish

![Start a new Flutter project](http://wx4.sinaimg.cn/large/006ar8zggy1g0cyaijpcwj30mu0i3q3y.jpg)

![Flutter application](http://wx4.sinaimg.cn/large/006ar8zggy1g0cyie6pehj30ru0nn3zo.jpg)

![flutter sdk ](http://wx4.sinaimg.cn/large/006ar8zggy1g0cyigbo29j30ru0nn75k.jpg)

![finish](http://wx4.sinaimg.cn/large/006ar8zggy1g0cyij36rtj30ru0nnjsk.jpg)

6、运行应用程序

![Flutter Demo Home Page](http://wx4.sinaimg.cn/large/006ar8zggy1g0cyqjwvnkj313n0q7wka.jpg)

---

可能遇到的问题：
##### 0. 任何访问不了网站，自动安装失败、下载失败等网络问题，自己想办法搞vpn fq。

- [阿里云 香港服务器 Centos7 3分钟搞定vpn](https://www.cnblogs.com/CyLee/p/10401766.html)

- [加速度](https://dc.36fy.com/)

##### 1. 启动Android Studio时，出现“Unable to access Android SDK add-on list”
点击 **"Cancel"**， 稍后再根据指引，自动安装即可。

##### 2. 其他常见配置问题
[https://book.flutterchina.club/chapter1/configuration.html](https://book.flutterchina.club/chapter1/configuration.html)