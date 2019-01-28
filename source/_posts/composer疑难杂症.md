---
title: composer疑难杂症
date: 2019-01-19 19:27:19
tags:
- cpmposer
- php
categories: 
- cpmposer
---

## The openssl extension is required for SSL/TLS protection

![](composer疑难杂症/1.png)

解决方法：在php.ini文件中打开php_openssl扩展 

```
extension=php_openssl.dll
```