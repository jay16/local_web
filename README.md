## 本地架构常用api网站

以ruby-doc为例

1. `gem install sinatra haml` 
2. 下载[ruby-doc](http://www.ruby-doc.org/downloads)到本地指定目录,并解压
3. 修改配置文档config.yaml[:local_web_dir]
4. 执行命令`thin start -p 80`或使用nginx启动。
5. 浏览器中输入127.0.0.1

### 配置实例

```
local_web$ cat config.yaml
local_web_dir: /Users/lijunjie/Code/local_web
local_web$ ls /Users/lijunjie/Code/local_web
api.rubyonrails.org ruby_1_9_3_core     www.bootcss.com     www.relishapp.com   www.sinatrarb.com
```

### nginx 配置
```
  server {
      listen 80;
      server_name 127.0.0.1;
      root my-path/ruby_1_9_3_core/public;
      passenger_enabled on;
      location /static {
        index index.html;
      }
   }
```

### 手工下载网站镜像

```
wget --mirror -w 2 --html-extension --convert-links -P /Users/lijunjie/Code/local_web  http://api.rubyonrails.org/
```
