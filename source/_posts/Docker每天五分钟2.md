---
title: 《Docker每天五分钟》二：切换 DaoCloud 镜像源
tags:
  - Docker
categories:
  - Docker
date: 2019-01-31 15:39:33
---

<hr>

切换国内 [DaoCloud](https://dashboard.daocloud.io/settings/profile) 镜像服务。 [免费注册](https://account.daocloud.io/signup)后进入控制台，找到右上角的[加速器图标](https://www.daocloud.io/mirror)。

![加速器](Docker每天五分钟2/3.png)

然后找到Linux的配置命令。

![配置 Docker 加速器](Docker每天五分钟2/1.png)

你的配置命令也许和我的不一样哦。

```bash
$ curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io

$ sudo systemctl restart docker
```



