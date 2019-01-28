---
title: Centos7 依赖全家桶
date: 2019-01-24 21:20:17
tags:
- centos
- yum
categories: 
- centos
---

<hr>

该文收集我安装 Centos7 环境中所有依赖的第三方包。只需要执行以下一句代码即可：
```bash
$ sudo yum install \
gcc-c++ \
zlib-devel \
pcre-devel \
libxml2 \
libxml2-devel \
yum-utilsdevice-mapper-persistent-data \
lvm2 \
yum-utils \
```