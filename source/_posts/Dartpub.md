---
title: Dart（Flutter） pub 包管理
tags:
  - Dart
  - Flutter
  - pub
categories:
  - Dart
  - Flutter
date: 2019-02-21 11:22:43
---

<hr>

Pub（https://pub.dartlang.org/ ）是Google官方的Dart Packages仓库，类似于node中的npm仓库，android中的jcenter，我们可以在上面查找我们需要的包和插件，也可以向pub发布我们的包和插件。我们将在后面的章节中介绍如何向pub发布我们的包和插件。

# 示例
接下来，我们实现一个显示随机字符串的widget。有一个名为“english_words”的开源软件包，其中包含数千个常用的英文单词以及一些实用功能。我们首先在pub上找到english_words这个包，确定其最新的版本号和是否支持Flutter。

![english_words](http://wx4.sinaimg.cn/large/006ar8zggy1g0duqg9p60j30y105e0ta.jpg)

我们看到“english_words”包最新的版本是3.1.3，并且支持flutter，接下来：

将english_words（3.1.3版本）添加到依赖项列表，如下：

```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^0.1.0
  # 新添加的依赖
  english_words: ^3.1.3
```

### 下载包

在Android Studio的编辑器视图中查看pubspec.yaml时，单击右上角的 Packages get 。
![Packages get](http://wx4.sinaimg.cn/large/006ar8zggy1g0dur11rqtj30dp0a8ab5.jpg)

这会将依赖包安装到您的项目。您可以在控制台中看到以下内容：
```
flutter packages get
Running "flutter packages get" in flutter_in_action...
Process finished with exit code 0
```

## 使用
1、引入english_words包
```dart
import 'package:english_words/english_words.dart';
```

在输入时，导入后该行代码将会显示为灰色，请放心，这并不一定是安装失败导致的。它表示导入的库尚未使用。

![import 'package:english_words/english_words.dart';](http://wx4.sinaimg.cn/large/006ar8zggy1g0dvh5ytdej30hd030t8r.jpg)

2、使用english_words包来生成随机字符串。
```dart
class RandomWordsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 生成随机字符串
    final wordPair = new WordPair.random();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Text(wordPair.toString()),
    );
  }
}
```
3、我们将 RandomWordsWidget 添加到"计数器"示例的首页MyHomePage 的Column的子widget中。

![RandomWordsWidget](http://wx4.sinaimg.cn/large/006ar8zggy1g0dvh87tibj30oy0oktay.jpg)

![RandomWordsWidget](http://wx4.sinaimg.cn/large/006ar8zggy1g0dvhap38oj30cr0mstai.jpg)

## 热更新

如果应用程序正在运行，请使用热重载按钮【⚡】更新正在运行的应用程序。每次单击热重载或保存项目时，都会在正在运行的应用程序中随机选择不同的单词对。 这是因为单词对是在 build 方法内部生成的。每次热更新时，build方法都会被执行。

![⚡](http://wx4.sinaimg.cn/large/006ar8zggy1g0dvhib782j30nx02bq2x.jpg)
