---
title: Centos7 Nodejs 安装
date: 2019-01-24 21:12:28
tags:
- Nodejs
- centos
categories: 
- centos
- Nodejs
---

<hr>

### 操作预览
1. 下载nodejs： https://nodejs.org/en/download/
2. 检查配置是否健康
3. make 编译（大概需要半小时）
4. 安装（root）
5. 验证

###### 1. 下载nodejs： https://nodejs.org/en/download/
```bash
$ wget https://nodejs.org/dist/v10.15.0/node-v10.15.0.tar.gz
```

###### 2. 检查配置是否健康
```bash
$ ./configure
```

###### 3. make 编译（大概需要半小时）
```bash
$ make
```

###### 4. 安装（root）
```bash
$ sudo make install
```

###### 5. 验证安装是否成功
```bash
$ node -v 
v10.15.0
```