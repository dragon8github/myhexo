---
title: 善用 JavaScript 特性：闭包与IIFE
tags:
- JavaScript
categories:
- JavaScript
date: 2019-03-05 22:27:09
---

<hr>

一、使用 `IIFE` 优雅的解决 `setInterval` 首次不执行的尴尬。
```JavaScript
// 你的函数
const f = () => { ... }

// 立即执行并且轮询
const timer = (function(fn, t) {
    // 为了解决 setInterval 首次不执行的尴尬
    fn && fn()
    // 返回计时器timer
    return setInterval(fn, t)
})(f, 1500)
```

二、善用闭包，就可以轻松实现缓存模式、单例模式。

下面几个例子来体验闭包在实战中的作用。

> 这种也被称为 `“模块模式”` —— 现代模块化实现的基石

##### 1. 轻量级极简的蒙版层mask，十分方便扩展：
```JavaScript
var Mask = function (cb) {
	var div = document.createElement('div')
	div.style = 'background-color: rgba(255, 255, 255, 0.7);position: fixed; top: 0; right: 0; bottom: 0; left: 0; z-index: 199307100337; display:none;'
	div.addEventListener('click', cb)
	document.body.append(div)

	var img = new Image()
	img.src = "http://wx3.sinaimg.cn/small/006ar8zggy1g0isbtuj2kg300w00wq2p.gif"
	img.style = 'position: absolute; top: 50%; left: 50%;'
	div.append(img)

	var show = function (showcb) {
		div.style.display = 'block'
		showcb && showcb()
	}

	var close = function (showcb) {
		div.style.display = 'none'
		showcb && showcb()
	}

	return { show, close }
}

// 创建一个蒙版
const mask = new Mask()
// 打开蒙版
mask.show()
// 三秒后关闭
setTimeout(() => {
	mask.close()
}, 3500);
```

##### 2. 巧妙使用闭包实现去重复

我有一个这样的需求：需要从指定区间（比如-7 ~ 7）随机取 5 个数，虽然说是随机，但却不想重复。用闭包缓存已经取过的数，每次取的时候递归过滤一下即可。

```JavaScript
'use strict';

// 缓存函数
var singeFn = function (fn, maxPollTime = 20) {
	// 缓存
	var cache = []
	// 轮询次数
	var pollTime = 0
	// 返回随机数生成器
	return function _ () {
		// 获取随机数
		var data = fn.apply(this, arguments)
		// 如果存在则递归
		if (~cache.indexOf(data)) {
			// 递归调用（如果递归次数大于阈值，那么直接返回False）
			return ++pollTime > maxPollTime ? false : _.apply(this, arguments)
		} else {
			// 重置轮询次数
			pollTime = 0
			// 添加缓存并且返回data
			return cache.push(data), data
		}
	}
}

// 我的随机函数
var random = function(min, max) {
    if (max == null) {
      max = min;
      min = 0;
    }
    return min + Math.floor(Math.random() * (max - min + 1));
};

// 从-7，7取随机数
var rangeRadom = random.bind(null, -7, 7)

// 返回一个新的函数
var singeRangeRadom = singeFn(rangeRadom);

// 获取返回值（每次都不一样）
for (var i = 0; i < 5; i++) {
    const randnum = singeRangeRadom()
    console.log(randnum)
}
```

##### 3. 用闭包可以实现缓存模式，减少不必要的重复计算消耗。
譬如比较实用的 `memoized`，我称之为 `参数标记缓存器`，源码和使用示例如下：
```
const memoized = fn => {
	const lookupTable = {};
	// 可以通过解释这个来观察缓存的变化
	// setInterval( () => console.log(lookupTable) , 1000); 
	return arg => lookupTable[arg] || (lookupTable[arg] = fn(arg));
}

// 阶乘的demo
let fastFactorial = memoized(n => {
	if (n === 0) {
		return 1;
	}
	// 这是一个递归，并且每一次递归都具有缓存过程
	return n * fastFactorial(n -1);
});

fastFactorial(5)
```

我的博客中`站内静态搜索功能`，就是使用了 `memoized`  的特性来优化性能，减少重复的搜索。

![](http://wx2.sinaimg.cn/large/006ar8zggy1g0s9womogeg30ku0cwqhw.gif)

如图，当我输入 “centos” 的时候，实际上是分别对 
> "c", "ce", "cen", "cent", "cento", "centos" 

关键字分别进行了:

> 搜索 -> 过滤 -> 模板引擎 -> 渲染UI

那么问题来了，如果按下六次“BackSpace”。也就是变成了 

> "cento", "cent", "cen", "ce", "c", ""

是否又得重复进行上述的运算操作呢？

显然是不必的，因为每一次输入关键词，我都会搜索一下缓存是否存在相关的内容，如果不存在则会缓存起来。如果存在则拿来即用。这样就减少了大量的计算消耗。直接跳到最后一步“渲染UI”了。