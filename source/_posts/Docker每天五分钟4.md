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



> Dockerfile 支持以 ‘#’ 开头注释

<!--more--> 

|	命令   |		功能      |
|----------|:------------:|
| FORM | 指定 base 镜像 |
| MAINTAINER | 设置镜像的作者，可以是任意字符串 |
| RUN | （命令三兄弟之一）在容器中运行指定命令。 |
| CMD | （命令三兄弟之一）在容器启动时运行指定的命令。 |
| ENTRYPOINT | （命令三兄弟之一）设置容器启动时运行的命令。 |
| COPY | 将文件复制到镜像，`COPY src desc` 与 `COPY ["src", "desc"]` |
| ADD | 与COPY类似，将文件复制到镜像。不同的是如果src是归档文件（zip、taz、xz等），文件会被自动解压 |
| ENV | 设置环境变量，环境变量可被后面的指令使用如： <br> `ENV MY_VERSION 1.9.1 RUN yum install -y mypackage=$MY_VERSION` |
| WORKDIR | 设置镜像中当前工作目录（服务于COPY、ADD、CMD、RUN、ENTRYPOINT等指令）。 |
| EXPOSE | 指定容器中的进程会监听某个端口， Docker 可以将该端口暴漏出来。 |
| VOLUME | 将文件或目录声明为 volume。 |

注意点：
- Dockerfile 中可以有多个 CMD 指令，但只有最后一个生效。
- Dockerfile 中可以有多个 ENTRYPOINT 指令，但只有最后一个生效。
- CMD 指令会被 `$ docker run [image] ...` 之后的参数替换掉。 如  `$ docker run [image] /bash/bin`
- CMD 或 docker run 之后的参数会被当做参数传递给ENTRYPOINT。

