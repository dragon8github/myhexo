---
title: 更优雅的防止请求(XHR)重复 —— 请求队列
tags:
  - xhr
  - axios
categories:
  - xhr
date: 2019-03-05 10:59:17
---

<hr>
问题：重复请求的问题在开发中很常见，浪费网络资源倒是其次，最怕的是前一次的点击逻辑，把后面的逻辑覆盖了。

> 譬如，你在列表中点击了“吴彦祖”，然后再快速点击了“吴孟达”。假设“吴彦祖”的数据请求需要3秒，而“吴孟达”只需要2秒，那么结果就是，页面会先渲染出“吴彦祖”，而后又马上“吴孟达”的数据覆盖。
>
> **用户本来是想查看“吴彦祖”的照片，而界面展示的却是“吴孟达”……**

<!--more--> 

![](http://wx2.sinaimg.cn/large/006ar8zggy1g0rnnuad9uj30dl06xgmp.jpg)

常见的防止重复请求的解决方案，就是展示一个蒙版或者Loading层，拦截用户进一步操作。直到逻辑全部跑通为止。

但在大数据屏幕中，如果拦截用户操作，并且赫然出现一个菊花图，是很Fu*k的体验。作为一个开发我自己看到菊花都烦：

![](http://wx4.sinaimg.cn/large/006ar8zggy1g0isbtuj2kg300w00wq2p.gif)

不过，这种不好的体验并不是源于菊花图，而是拦截了用户操作。让用户放不开。所以需求是：

> 你随便瞎几把乱点，重复请求了算我输。

### 请求队列

1. 把所有请求都塞入一个队列；
2. 每当一个请求进入队列之前，先清空并取消（Cancel）队列中**相同的请求**；
3. 当一个请求完成，要将自己从队列中移除；


![](http://wx4.sinaimg.cn/large/006ar8zggy1g0ro3c0myvj30dw09udgm.jpg)

重点在于如何 **取消（Cancel）** 已经发送的请求。实际上还真有，原生的 XHR 就有提供 abort() 可以中断请求。jQuery 的 Ajax 也提供了：https://github.com/jquery/jquery/blob/master/src/ajax/xhr.js#L82

```JavaScript
const xhr = ajax({ ... })
xhr.abort()
```

axios 也提供了类似的API，不过用起来比上面的麻烦一点，详情使用在后续的demo中：
```JavaScript
new axios.CancelToken(_ => { ... })
```

虽然大部分项目已经是采用 axios、fetch等现代XHR请求技术了。但还是用传统的jQuery Ajax更容易说明，反正原理是一样的：

singeAjax.html:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SingleAjax</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- jquery -->
    <script src="https://cdn.bootcss.com/jquery/1.9.1/jquery.min.js"></script>
    <style>
    </style>
</head>

<body>
</body>
<script>

// 获取纯Url，不包含?后面的参数
var getPureUrl = url => {
	const index = url.indexOf('?')
	return url.substr(0, ~index ? index : url.length)
}

//（核心）以url相同作为重复条件，你可以根据自己的情况编写自己的重复条件
var SingleAjax = function () {
    // 缓存的队列
    var pending = [];

    // 返回单例模式ajax
    return function (opts) {
    	// 获取纯Url（不包含?后面的参数）
    	const pureUrl = getPureUrl(opts.url)
        // 中止队列中所有相同请求地址的xhr
        pending.forEach(_ => _.url === pureUrl && _.xhr.abort());
        // 获取 success 回调函数
        const _success = opts.success
        // 装饰成功回调函数
        opts.success = function (...rest) {
        	// 从队列过滤掉已经成功的请求
        	pending = pending.filter(_ => _.url != pureUrl)
        	// 继续执行它的成功
        	_success && _success(...rest)
        }
        // 移除所有中止的请求，并且将新的请求推入缓存
        pending = [...pending.filter(_ => _.url != pureUrl), { url: pureUrl, xhr: $.ajax(opts) }]
    }
}

// 生成单例ajax
var singleAjax = new SingleAjax()

for (var i = 0; i < 10; i++) {
    singleAjax({
        url: "https://api.github.com/users/dragon8github",
        success: function (data) {
            // 其实在成功之后，可以考虑扩展把成功的xhr从队列中移除，但其实也不影响。已经成功的xhr就算再次被执行abort也不会怎么样，更不会从200变成cannel状态，更不会触发error。
            console.log('请求成功', data);
        },
        error: function(e, m){
           console.log('数据接口请求异常（请放心这是正常现象，由于请求被中止Cancel，所以会回调error。只需要判断一下m === "abort" 即可，你还可以在 abort() 时在 _.xhr 中加入任意属性来判断深入判断）', e, m, m === "abort");
        }
    })
}
</script>
</html>
```

代码中我们模拟了十次重复的请求，发现前9次都被abort了。只留下最后一条。

![](http://wx3.sinaimg.cn/large/006ar8zggy1g0rqu574qbj314m0htmz1.jpg)


下面是axios的示例 singeAxios:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.18.0/axios.min.js"></script>
</head>
<body>
</body>
<script>
// 请求队列
let pending = []

// 获取纯Url，不包含?后面的参数
var getPureUrl = url => {
	const index = url.indexOf('?')
	return url.substr(0, ~index ? index : url.length)
}

// 请求拦截器
axios.interceptors.request.use(config => {
    // 获取纯Url（不包含?后面的参数）
    const pureUrl = getPureUrl(config.url)
    // 中止队列中所有相同请求地址的xhr
    pending.forEach(_ => _.url === pureUrl && _.cancel('repeat abort'));
    // 配置取消令牌
    config.cancelToken = new axios.CancelToken(cancel => {
       // 移除所有中止的请求，并且将新的请求推入缓存
       pending = [...pending.filter(_ => _.url != pureUrl), { url: pureUrl, cancel }]
    })
    return config
}, error => {
    return Promise.reject(error)
})

// 响应拦截器
axios.interceptors.response.use(res => {
  // 成功响应之后清空队列中所有相同Url的请求
  pending = pending.filter(_ => _.url != getPureUrl(res.config.url))
  // 返回 response
  return res
}, error => {
   return Promise.reject(error)
});

for (var i = 0; i < 10; i++) {
    axios({url: 'https://api.github.com/users/dragon8github'}).then(console.log).catch(_ => {
        if (_.message === 'repeat abort') return console.info(_.message)
        // other error handler...
        // something code...
        throw new Error(_.message)
    })
}
</script>
</html>
```

axios 也是一样道理，只是做法不一样。前9个请求都被abort了。

![](http://wx4.sinaimg.cn/large/006ar8zggy1g0rr60x3knj30y30huwfa.jpg)

不过奇怪的是，并没有cancel的过程。就像从来没有发起请求过一样。

![](http://wx4.sinaimg.cn/large/006ar8zggy1g0rr5yplkjj30y30hudgw.jpg)
