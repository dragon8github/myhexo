---
title: npm 发布包和删除包（2019最新攻略）
tags:
  - npm
  - nodejs
categories:
  - npm
date: 2019-03-20 10:48:27
---

<hr>

> 📖 阅读本文大概需要 6 分钟。

### 操作概览
1. 验证你的包名是否重复。
2. npm 官网注册账号（略）。
3. npm init 初始化你的包。
4. 发布 npm publish。
5. 如何发布新版本？
6. 如何删除你的发布包？
7. 什么是 2FA？什么是 Authenticator App？什么是 One-time Password？
8. （后记）补充说明

#### 一、验证你的包名是否重复

1、直接上 [npmjs.com](https://www.npmjs.com/) 官网搜索

![](http://wx1.sinaimg.cn/large/006ar8zggy1g18zx67djmj30ry075756.jpg)

2、也可以用一些工具库查找，虽然有点画蛇添足，但某些场景还是适用的。比如动态发布包。

- [npm-name-cli](https://github.com/sindresorhus/npm-name-cli)

![](https://github.com/sindresorhus/npm-name-cli/raw/master/screenshot.gif)


---

> 二、[npm 官网](https://www.npmjs.com/login)注册账号（略）


---

#### 三、npm init 初始化你的包。

```bash
$ npm init -y
```

#### package.json

重点关注和修改以下三项：

- name：你的包名
- version：（推荐）用 jQuery 的版本规范：**0.0.1**
- main：你的入口文件

```json
{
  "name": "chuanghui-vue-portal",
  "version": "0.0.1",
  "main": "src/components/chuanghui-portal.vue",
  "description": "ChuangHui Vue Components",
  "author": "lizhaohong <928532756@qq.com>"
}
```

#### 四、发布 npm publish

先添加 npm 账号
```bash
$ npm adduser 
Username: ...
Password: ...
Email: (this IS public) 928532756@qq.com
Logged in as cylee on https://registry.npmjs.org/.
```

![](http://wx3.sinaimg.cn/large/006ar8zggy1g19101gkfzj30g003m0sr.jpg)

正式发布，就一句话。

```
$ npm publish
```

正常的话，在 npm 个人 package 页面中可以看到上传的包：

![](http://wx1.sinaimg.cn/large/006ar8zggy1g1911ff0s4j31h20fdwgp.jpg)

#### 五、迭代新版本

只需要把你 `package.json` 的 `version` 版本号改变，如 **0.0.1 -> 0.0.2**，再执行 `$ npm publish` 即可。


---


#### 六、删除发布包

> 如果你和我一样有强迫症，仅仅是修复一个 bug 就要把版本号从 0.0.1 升级到 0.02。
>
> 心里肯定很纠结，更多的可能是选择删掉包重新上传。

网上介绍删除发布包的方法倒也简单。执行以下即可：

```bash
$ npm unpublish --force
```

但你可能出现 `ERR：2FA` 之类的错误信息？那你可能要先进行一大堆设置了，看下去吧。

#### 七、什么是 2FA？什么是 Authenticator App？什么是 One-time Password？

简单概括：
- **2FA**： NPM 发布包管理的权限设置，可以在 NPM 后台配置；
- **Authenticator App**：是微软 Microsoft 出品的一款实时密码App，请自行到App商店搜索下载；
- **One-time Password**：Authenticator App 输出的实时密码。

具体设置步骤：[官方教程](https://docs.npmjs.com/configuring-two-factor-authentication)

1、到 App 商店搜索并且下载 Microsoft Authenticator App.


2、进入 npm 后台，找到如图所示：
![](http://wx3.sinaimg.cn/large/006ar8zggy1g191w9ghp3j318n0myacc.jpg)

3、选择 [Authorization and Publishing] - [submit]

![](http://wx2.sinaimg.cn/large/006ar8zggy1g191xx4oacj30gt0nidh6.jpg)

4、打开 Authenticator App，选择 “添加账户” - “其他账户（Google、Facebook 等）”

![](http://wx3.sinaimg.cn/large/006ar8zggy1g192bkruiyj30cd09ydh9.jpg)

5、扫描 `步骤3` 后的二维码。

6、体验  One-time Password。如图所示

![](http://wx2.sinaimg.cn/large/006ar8zggy1g192dhbrgyj30c106sq3w.jpg)

7、使用 One-time Password 删除发布包。需要加上 --otp <One-time Password>

```bash
$ npm unpublish chuanghui-portal --force --otp 863613
```

#### 八、（后记）

开通了 2FA 以后，你的账号发布包`$ npm publish` 都是需要使用 One-Time Password的。

```bash
$ npm publish --otp 863613
```