---
title: 《Docker每天五分钟》八：Dockerfile 中的命令三兄贵
tags:
  - Docker
categories:
  - Docker
date: 2019-02-11 20:29:04
---

<hr>

# RUN vs CMD vs ENTRYPOINT

简单地说：
（1）RUN： 该命令会创建一个镜像层，适合在安装软件包的时候使用。
（2）CMD： 配置容器启动后默认执行的命令及其参数，但 CMD 会被 `$ docker run` 后面跟的命令行参数替换。比如 `$ docker run -it [image] /bash/bin`， 那么 CMD 指令会被忽略掉。
（3）ENTRYPOINT：配置容器启动时运行的命令。

# RUN
RUN 指令会创建新的镜像层。 通常用于安装应用和软件包。 Dockerfile 中常常包含多个 RUN 指令。

RUN 有两种格式：
（1） **Shell 格式（推荐）： `RUN yum update && yum install gcc-c++\vim\git -y`**
（2） Exec 格式： `RUN ["yum", "install", "gcc-c++", "vim", "git", "-y"]`

> 注意，我们反复提到 RUN 指令会创建新的镜像层。镜像层的概念就类似缓存。会在各个地方的dockerfile被反复使用。
> 这里 yum update 放在和安装同一个指令中。能保证每次安装都是最新的包。如果 yum update 单独的RUN。则会创建一个 yum update 的镜像层。当其他地方的d ockerfile 使用 yum update 的时候，就会直接使用该镜像层，而这一层很可能是很久以前缓存的了。

# CMD
此命令会在容器启动后运行。 前提是 `$ docker run` 没有指定其他命令。
- 如果 docker run 指定了其他命令， CMD 指定了默认命令将被忽略。
- 如果 Docker file 中有多个 CMD 指令，只有最后一个 CMD 有效。

CMD 有三种格式：
（1） **Exec 格式（推荐）： CMD ["/bin/echo", "Hello World"]**
（2） 嫁衣格式： CMD ["param1", "params2"]
（3） Shell格式： CMD echo "Hello World"

> （2）嫁衣格式是为 ENTRYPOINT 提供参数，此时 ENTRYPOINT 必须使用 Exec 格式。

举例说明 CMD 和 `$ docker run` 的关系，Dockerfile 片段如下：

```dockerfile
CMD echo "Hello world"
```
运行容器 `$ docker run -it [image]` 将输出：
```
Hello world
```
但如果加上命令： `$ docker run -it [image] /bin/bash`， CMD 会被忽略掉。也就没有输出 `Hello world` 了

# ENTRYPOINT

ENTRYPOINT 指令可以让容器以应用程序或者服务的形式运行。

ENTRYPOINT 与 CMD 很相似，它们都可以指定执行的命令和参数。不同的地方在于 ENTRYPOINT 不会被 `$ docker run` 时指定的命令忽略。

ENTRYPOINT 有两种格式：
（1） **Exec 格式（推荐）： ENTRYPOINT ["executable", "param1", "param2"]**
（2）Shell 格式：ENTRYPOINT command param1 param2

> ENTRYPOINT 不同的格式效果差别巨大。 选择使用时必须小心。
> ENTRYPOINT 的 Exec 格式可以接受 CMD 或 `$ docker run` 提供的参数。
> ENTRYPOINT 的 Shell 格式会忽略任何 CMD 或 `$ docker run` 提供的参数。

### ENTRYPOINT 的 Exec 格式

ENTRYPOINT 的 Exec 格式可以接受 CMD 或 `$ docker run` 提供的参数。 比如下面的 Dockerfile 片段：
```dockerfile
ENTRYPOINT ["/bin/echo", "Hello"] CMD ["world"]
```
当容器通过 `$ docker run -it [image]` （无命令）启动时，输出为：
```
Hello world
```

而如果通过 `$ docker run -it [image] CloudMan` 启动时，则输出为：
```
Hello CloudMan
```

# Exec 格式 与 变量 shell 解析

> 请注意，当需要解析变量时，应该使用 Shell 解析，如/bin/sh（bash） 

例如下面的 Dockerfile 片段，我们用 ENV 指令设置了环境变量 $name 并不会被解析：

```dockerfile
ENV name Cloud Man ENTRYPOINT ["/bin/echo", "Hello, $name"]
```

运行容器将输出： 
```shell
Hello, $name
```

> 注意：环境变量 $name 没有被替换。必须使用 shell 解析。

如果希望使用环境变量，如下修改 Dockerfile：
```dockerfile
ENV name Cloud Man ENTRYPOINT ["/bin/sh", "-c", "echo Hello, $name"]
```

运行容器将输出： 
```shell
Hello, Cloud Man
```