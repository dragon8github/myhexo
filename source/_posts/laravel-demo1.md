---
title: Laravel 入门示例（一）：初识控制器与路由
date: 2019-01-19 21:46:39
tag:
- laravel
- php
categories:
- php
- laravel
---

1、先用 **artisan** 命令新建一个 **Controller**，命名为 **SitesController**

```bash
$ php artisan make:controller SitesController
```

生成的文件在目录： **\app\Http\Controllers\SitesController.php**，添加内容如下：

```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class SitesController extends Controller
{
    // Route::get('/', 'SitesController@index');
    public function index () {
    	return view('welcome');
    }
}


```

这里的 welcome 页面是在：**\resources\views\welcome.blade.php**

<!--more--> 

2、打开 **\routes\web.php**，修改内容为：

```php
<?php

// Route::get('/', function () {
//     return view('welcome');
// });

Route::get('/', 'SitesController@index');
```

刷新页面，一切如故。 