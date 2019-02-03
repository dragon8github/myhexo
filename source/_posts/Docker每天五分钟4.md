---
title: 《Docker每天五分钟》四：常用api
tags:
  - Docker
categories:
  - Docker
date: 2019-01-31 17:09:30
---

<hr>


|	命令   |		功能      |
|----------|:------------:|
| $ docker images |  查看所有镜像 |
| $ docker ps -a | 查看所有容器   |
| $ docker run -it <镜像> | 运行本地镜像，如果镜像不存在则下载最新版本  |
| $ docker exec -it <已启动容器> /bin/bash | 以交互的方式进入已启动的容器内部  |
| $ docker stop <容器> | 停止容器  |
| $ docker start <容器> | 启动容器  |
| $ docker rm <容器> | 删除容器，必须先停止容器 |
| $ docker rmi <镜像> | 删除镜像，必须先删除所有依赖该镜像的容器 |
| $ docker build -t <新建容器名> . | 通过 Dockerfile 构建镜像，<br>请注意最后一个`.` 指明在当前路径寻找 Dockerfile |
| $ docker history <镜像> | 查看镜像的构建层级 |




