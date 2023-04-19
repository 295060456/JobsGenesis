# Web服务器学习

## 资料来源：

```
https://blog.51cto.com/willis/1852083
```

## ======  前言 ====== 

MacOS 自带tomcat和apache，但是建议都用brew重新下载进行额外的管理

```bash
which -a apache
which apache
```

查找用brew管理的软件的安装路径（以tomat为例）：

```bash
brew list tomcat
```

## ====== tomcat ======

【安装】brew install tomcat

进入tomcat安装目录下的libexec/bin，执行里面对应的sh，以实现【开启】【关闭】【重启】

## ====== httpd ======

```
【安装】brew install httpd
【启动】apachectl start
【停止】apachectl stop   
【重启】apachectl restart
```

【备注】

1、默认占用系统8080端口，俗称apache

2、open /etc/apache2/httpd.conf，(因为是只读所以需要加写权限)，然后将默认的8080更改为8081，以及80更改为81（防止其他程序抢夺端口）

```
<IfDefine SERVER_APP_HAS_DEFAULT_PORTS>
  Listen 8081
</IfDefine>
<IfDefine !SERVER_APP_HAS_DEFAULT_PORTS>
  Listen 81
</IfDefine>
```

## ====== nginx ======

```bash
【安装】brew install nginx
【启动】nginx
【关闭】nginx -s stop（相当于先查出nginx进程id再使用kill命令强制杀掉进程）
【重启】nginx -s reload
【停止】nginx -s quit（待nginx进程处理任务完毕进行停止）
【重读日志文件】nginx -s reopen
```

【备注】

​	1、默认占用系统8080端口

​	2、如果端口被占用则报错如下：

```
nginx: [emerg] bind() to 0.0.0.0:8080 failed (48: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:8080 failed (48: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:8080 failed (48: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:8080 failed (48: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:8080 failed (48: Address already in use)
nginx: [emerg] still could not bind()
```

​	3、查询

​		3.1、查询某个软件（比如：Nginx）的进程号

```
ps aux|grep nginx
```

​		3.2、查询端口占用情况（比如查询8080端口）

```
lsof -i tcp:8080
```

​		3.3、查询由brew管理的nginx的安装目录

```
brew list nginx
```

​		3.4、查询nginx的配置文件目录

```
nginx -t（安装目录 ≠ 配置文件目录）
```

