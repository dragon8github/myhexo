---
title: 请求缓存策略
tags:
  - JavaScript
  - axios
categories:
  - JavaScript
date: 2019-03-06 10:54:53
---

<hr>

该代码摘抄自  [ant-design-pro](https://github.com/ant-design/ant-design-pro/blob/master/src/utils/request.js#L66) 

https://github.com/ant-design/ant-design-pro/blob/master/src/utils/request.js#L66

只要不是实时数据的接口，基本上都可以充分利用请求缓存的特性，节约客户端网络资源的浪费，也减少服务器的请求压力。

特别是我的项目中的数据，最短的迭代周期也是“每日一更”。所以缓存特性可以放心大胆使用。但为了保险，缓存生命周期还是设置短一点。比如1分钟。

原理大致是这样的：
1. 每次请求都先判断是否存在缓存，如果没有则存起来，如果有则需要判断缓存是否过期，如果过期则还是要请求，否则才返回缓存；
2. 每次存之前，判断缓存是否满了？（sessionStoreage的容量大概5M），如果满了则需要清空再存入。值得注意的是，如果数据体积超过5M（几十万数据），那你清空存入还是会报错。所以我们存入之前要判断数据体积是否大于5M，如果是则不加入缓存；


#### 问题一：如何判断你浏览器的缓存容量，可以手动执行以下代码。不出意外肯定是5120kb。

```JavaScript
// 获取localStorage最大容量
(function() {
   if(!window.sessionStorage) {
        console.log('当前浏览器不支持sessionStorage!')
   }    
   var test = '0123456789';
   var add = function(num) {
     num += num;
     if(num.length == 10240) {
       test = num;
       return;
     }
     add(num);
   }
   add(test);
   var sum = test;
   var show = setInterval(function(){
      sum += test;
      try {
       window.sessionStorage.removeItem('test');
       window.sessionStorage.setItem('test', sum);
       console.log(sum.length / 1024 + 'KB');
      } catch(e) {
       console.log(sum.length / 1024 + 'KB超出最大限制');
       clearInterval(show);
      }
   }, 0.1)
 })()


// 获取sessionStorage的剩余容量
(function(){
    if(!window.sessionStorage) {
        console.log('浏览器不支持sessionStorage');
    }
    var size = 0;
    for(item in window.sessionStorage) {
        if(window.sessionStorage.hasOwnProperty(item)) {
            size += window.sessionStorage.getItem(item).length;
        }
    }
    console.log('当前sessionStorage剩余容量为' + (size / 1024).toFixed(2) + 'KB');
})()
```

![](http://wx2.sinaimg.cn/large/006ar8zggy1g0sufs054qg30lq0ny4go.gif)

#### 问题二：以什么作为缓存键（sessionStorage keys）？

1. Url：请求地址，含 “?” 后面的 GET 参数;
2. Options：包含 headers 和 params、body 等;
3. Other：譬如有一些公共参数通常是在 `interceptors request` 请求拦截器中才添加的。如果没有则不计入。

```
import hash from 'hash.js'

// 缓存键（指纹） = 请求url + 请求配置 + 其他特殊参数
const fingerprint = Url + Options + Other;
// 加密混淆
const hashcode = hash( fingerprint )
```


#### 问题三：sessionStorage 是没有过期和生命周期的概念的，需要怎么实现？

需要新建一个特殊的键来记录该缓存录入的时间，比如：

```JavaScript
// 设置缓存
sessionStorage.setItem(hashcode, JSON.stringify(content))
// 同时，设置该缓存的录入时间
sessionStorage.setItem(`${hashcode}:timestamp`, Date.now())
```

判断缓存是否过期（这里省略了判断缓存是否存在的代码）：
```JavaScript
// 我们约定缓存的过期时间是60秒
const expirys = 60 

// 获取该缓存的录入时间
const whenCached =  sessionStorage.getItem(`${hashcode}:timestamp`)

// 判断缓存过去了多久时间了
const age = (Date.now() - whenCached) / 1000

// ...如果缓存没有过期
if (age < expirys) {
    console.log('use cache')
} else {
    console.log('no cache')
}
```

#### 问题四：如何捕捉 sessionStorage 超出?
错误名为 `"QuotaExceededError"`
> 值得注意的是，尽管你清空缓存再重新存入，内容体积如果是大于5M依然会再度报错。所以最好限制缓存的大小。如果大于某个体积（譬如2M），则不存入缓存。

```JavaScript
/**
 * say something ...
 *
 * @hashcode  {String}   缓存键
 * @content   {String}   缓存值
 */
const cachedSave = (hashcode, content) => {
    try {
    // 返回code500是后端固定的报错反馈 && 不能为空对象 && 数据的小于2M
    if (content.code != 500 && !isEmptyObject(content) && (JSON.stringify(content).length / 1024).toFixed(2) < 2048) {
      // 设置缓存
      sessionStorage.setItem(hashcode, JSON.stringify(content))
      // 设置缓存时间
      sessionStorage.setItem(`${hashcode}:timestamp`, Date.now())
    }
  } catch (err) {
      // 超出缓存大小
      if (err.name === 'QuotaExceededError') {
        // 清空所有缓存
        sessionStorage.clear()
        // 重新设置缓存
        sessionStorage.setItem(hashcode, JSON.stringify(content))
        // 重新设置缓存时间
        sessionStorage.setItem(`${hashcode}:timestamp`, Date.now())
      }
  }

  // 返回Promise
  return content
}
```

#### 问题五：如何加密指纹（sessionStorage keys）？
可以使用开源的第三方库： `hash.js`
https://github.com/indutny/hash.js

使用示例：
```JavaScript
var hash = require('hash.js')
hash.sha256().update('你需要加密的数据').digest('hex')
```


## 最终代码
request.js:
```JavaScript
import axios from 'axios'
import hash from 'hash.js'

// 判断是否为一个空对象：{}
const isEmptyObject = obj => {
    if (Object.getOwnPropertyNames) {
        return (Object.getOwnPropertyNames(obj).length === 0);
    } else {
        var k;
        for (k in obj) {
            if (obj.hasOwnProperty(k)) {
                return false;
            }
        }
        return true;
    }
}

// 检查状态码
const checkStatus = (response) => {
  // 判断请求状态
    if (response.status >= 200 && response.status < 300) {
        // 返回Promise
        return response.data
    } else {
      // 服务器响应异常
      throw new Error(response.statusText)
    }
}

// 缓存到sessionStorage
const cachedSave = (hashcode, content) => {
    try {
    // 返回code500是后端固定的报错反馈 && 不能为空对象 && 数据的小于2M
    if (content.code != 500 && !isEmptyObject(content) && (JSON.stringify(content).length / 1024).toFixed(2) < 2048) {
      // 设置缓存
      sessionStorage.setItem(hashcode, JSON.stringify(content))
      // 设置缓存时间
      sessionStorage.setItem(`${hashcode}:timestamp`, Date.now())
    }
  } catch (err) {
      // 超出缓存大小
      if (err.name === 'QuotaExceededError') {
        // 清空所有缓存
        sessionStorage.clear()
        // 重新设置缓存
        sessionStorage.setItem(hashcode, JSON.stringify(content))
        // 重新设置缓存时间
        sessionStorage.setItem(`${hashcode}:timestamp`, Date.now())
      }
  }

  // 返回Promise
  return content
}

// 公共请求
export const request = (url, options = {}) => {
    // 指纹
    const fingerprint = url + JSON.stringify(options)
    // 加密指纹
    const hashcode = hash.sha256().update(fingerprint).digest('hex')
    // 预设值指纹
    const _cachedSave = cachedSave.bind(null, hashcode)
    // 过期设置
    const expirys = options && options.expirys || 60
    // 本请求是否禁止缓存？
    if (expirys !== false) {
        // 获取缓存
        const cached = sessionStorage.getItem(hashcode)
        // 获取该缓存的时间
        const whenCached = sessionStorage.getItem(${hashcode}:timestamp)
        // 如果缓存都存在
        if (cached !== null && whenCached !== null) {
          // 判断缓存是否过期
          const age = (Date.now() - whenCached) / 1000
          // 如果不过期的话直接返回该内容
          if (age < expirys) {
              // 新建一个response
              const response = new Response(new Blob([cached]))
              // 返回promise式的缓存
              return new Promise((resolve, reject) => resolve(response.json()))
          }
          // 删除缓存内容
          sessionStorage.removeItem(hashcode)
          // 删除缓存时间
          sessionStorage.removeItem(${hashcode}:timestamp)
        }
    }
    return axios(url, options).then(checkStatus).then(_cachedSave)
}
```


### 如何使用 request.js？

Login.js 示例

```JavaScript
import { request } from '@/utils/request.js'
import qs from 'qs'

request('/admin/user/sysUser/login', {
  method: 'POST',
  headers: {'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8'},
  data: qs.stringify({ userAccount, userPwd, type: 'account' })
}).then(data => {
    // ...
})
```
