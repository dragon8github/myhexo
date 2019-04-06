---
title: 网页无法播放MP4的解决方案
date: 2019-01-25 14:51:40
tags:
- MP4
- video
- HTML
categories: 
- HTML
- video
- MP4
---

<hr>

### 操作预览：
1. 下载 `格式工厂`
2. 选择 MP4 导入你需要转换的视频
3. 右键列表中的视频选择 `输出配置`，选择 `视频编辑：AVC（H264）`
4. 点击开始

<!--more--> 

![网页无法播放MP4的解决方案](/1.png)

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
    #myVideo {
        position: fixed;
        left: 0;
        right: 0;
        top: 0;
        z-index: 199307100337;
    }
    </style>
</head>

<body>
    <video autoplay loop muted id="myVideo">
        <source src="./saber.mp4" type="video/mp4">
    </video>
</body>
</html>
```

![saber.mp4](网页无法播放MP4的解决方案/2.png)