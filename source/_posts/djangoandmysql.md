---
title: django 与 mysql 勾结指南
tags:
  - django
  - mysql
categories:
  - django
date: 2019-04-14 19:33:04
---

<hr>

> 📖 阅读本文大概需要 26 分钟。

参考文章：

https://blog.51cto.com/eagle6899/2146972

https://blog.csdn.net/qq_36963372/article/details/82558085

#### 第一步：配置 setting.py

```python
# Database
# https://docs.djangoproject.com/en/2.2/ref/settings/#databases

DATABASES = {
    'default': {
        # 'ENGINE': 'django.db.backends.sqlite3',
        # 'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
        
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'mydatabase',
        'USER': 'root',
        'PASSWORD': 'root',
        'HOST': '127.0.0.1',
        'PORT': '3306',
    }
}
```

#### 第二步：执行 migrate 

```
$ python manage.py migrate
```

不出意外会让你安装 `mysqlclient`

```
$ pip install mysqlclient
```

你能下载成功，但可能安装失败。提示类似 **`“_mysql.c(29): fatal error C1083: 无法打开包括文件: “mysql.h”: No such file
or directory”`**  的信息。

> 总而言之，这是 window 开发者需要背负的穷罪。

解决方案都在这里：https://www.lfd.uci.edu/~gohlke/pythonlibs/#mysqlclient

我们的目标是手动选择一个适合的 mysqlclient.whl ，然后编译。

---

#### 1、先安装 wheel，才可以编译 *.whl 文件

```
$ pip install wheel
```

#### 2、安装Microsoft Visual C++

Python 2.7：Microsoft Visual C++ 2008 ([x64](https://www.microsoft.com/en-us/download/details.aspx?id=15336), [x86](https://www.microsoft.com/en-us/download/details.aspx?id=29), and [SP1](https://www.microsoft.com/en-us/download/details.aspx?id=26368)) 

Python 3.x：Visual C++ 2017 ([x64 or x86](https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads)) 

#### 3、查看 pip 支持的版本

```
# AMD64
import pip._internal
print(pip._internal.pep425tags.get_supported())

# WIN32
import pip
print(pip.pep425tags.get_supported())
```

环境不同，输出不同，我的输入如下：

```
[('cp37', 'cp37m', 'win32'), ('cp37', 'none', 'win32'), ('py3', 'none', 'win32'), ('cp37', 'none', 'any'), ('cp3', 'none', 'any'), ('py37', 'none', 'any'), ('py3', 'none', 'any'), ('py36', 'none', 'any'), ('py35', 'none', 'any'), ('py34', 'none', 'any'), ('py33', 'none', 'any'), ('py32', 'none', 'any'), ('py31', 'none', 'any'), ('py30', 'none', 'any')]
```

根据我的支持表，我找到了文件： [mysqlclient-1.4.2-cp37-cp37m-win32.whl](https://download.lfd.uci.edu/pythonlibs/u2hcgva4/mysqlclient-1.4.2-cp37-cp37m-win32.whl)

你可以在这里查找：[https://www.lfd.uci.edu/~gohlke/pythonlibs/#mysqlclient](https://www.lfd.uci.edu/~gohlke/pythonlibs/#mysqlclient)

也可以在pip仓库查找各种历史版本：[https://pypi.org/project/mysqlclient/#files](https://pypi.org/project/mysqlclient/#files)

下载之后，进行安装

```
$ pip install mysqlclient-1.4.2-cp37-cp37m-win32.whl
```

成功了你会看到如下输出：
```
Processing c:\users\lee\downloads\mysqlclient-1.4.2-cp37-cp37m-win32.whl
Installing collected packages: mysqlclient
Successfully installed mysqlclient-1.4.2
```

如果是不正确的版本，你会出现如下报错：

**`mysqlclient-1.3.11-cp36-cp36m-win32.whl is not a supported wheel on this platform.`**

不需要担心，慢慢找到匹配 pip 的即可。

---

一切尘埃落定之后，重新执行一下最初的 migratemigrate 命令。

```
$ python manage.py migrate
```

如果你的 mysql 版本是 5.5（笔者用 phpstudy 最新版也只有5.5）。还会出现一个 SQL 错误的信息:

```
django.db.migrations.exceptions.MigrationSchemaMissing: Unable to create the django_migrations table ((1064, "You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax
to use near '(6) NOT NULL)' at line 1"))
```

MySQL5.5并不支持Django2.1生成的这种SQL语句。我选择安装了 mysql lastest 版本。既 (mysql8.0.15)[https://dev.mysql.com/downloads/mysql/]

如果不会安装，请参考我的另一篇建议笔记：[mysql 编译安装 window篇](https://www.cnblogs.com/CyLee/p/7421949.html)

或者参考网站 mysql 安装教程。总之要确保运行中的 mysql 服务版本是 5.5 以上。

在确保你的 mysql 是最新且能访问之后。重新执行一下该命令。

```
python manage.py migrate
```

如果成功会看到如下信息：

![](http://wx4.sinaimg.cn/large/006ar8zgly1g22e0ocrewj30k00clmzu.jpg)

再看看你的数据库，django 生成了不少实用的表。

![](http://wx2.sinaimg.cn/large/006ar8zgly1g22e019t2kj30n607ndhp.jpg)

（完）