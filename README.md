## 本地架构常用api网站

以ruby-doc为例

1. [ruby-doc](http://www.ruby-doc.org/downloads)下载ruby对应版本的doc到本地,并解压
2. `gem install sinatra` 
3. 把`sinatra.rb,config.ru`放至解压文件夹内,然后再在里面创建public文件夹
4. 执行命令`thin start -p 80`或使用nginx启动。
5. 浏览器中输入127.0.0.1

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

