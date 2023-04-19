# MacOS（本机）- MySql

## 多种方式安装和管理MySql

```mysql
1、用 brew 容器管理 MySql

brew install mysql
brew uninstall mysql 或者 brew remove mysql 

brew services restart mysql // 重启MySQL
brew services stop mysql // 关闭MySQL
brew services start mysql // 启动MySQL

注意：brew容器管理的MySql，使用基本MySql命令会失败或者无效
mysql.server stop
mysql.server start
mysql.server restart

2、从官网下载 MySql直接安装在本机（未验证）
open https://juejin.cn/post/6844903956305412104

3、用 Macport/brew/MySql 官网下载直接安装到本机的区别
	3.1、Macport 和 brew 作为容器管理着 MySql 的生命周期，那么对于 MySql 的服务开启\关闭、重启 等的命令方式不一样
	3.2、比如：如果直接在终端以官网下载部署到Mac系统这种方式的命令找出 MySql 的 pid ，对其进行kill -9 关闭是无效的（因为有中间过程值，关闭了又会被激活）
	3.3、关闭服务，即停止本机上任何对 MySql 的调用。MySql 的调用前提一定要激发其对外提供服务
	3.4、因为安全原因，MySql的某些版本对于忘记密码的操作不一样，也就是说可能都不存在教程上的文件和路径
	
4、关于版本号
  4.1、MySql 忽然从5.7升级到了8.0，直接跳过了6和7。即，版本号码：5.5/5.6/5.7/8.0
  4.2、MySql-8.0 以前的版本需要使用命令'brew link',不主动link的话，连mysql命令行都不能使用。即使能使用mysql命令行的话，也是会提示不能登陆，缺少caching_sha2_password.so文件。
  无奈之下，就只能选择清理 MySql 了。
  
  以MySql-5.7版本为例，即：
  
  brew install mysql@5.7
  brew link mysql@5.7 --force
  brew services start mysql@5.7
  mysql -uroot -p
```

## MySql 登录报错分析

```mysql
【MySql服务没有启动】
登录root账户
MySQL -u root -p
返回 →
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)
错误原因：服务未启动。
因为通过命令验证brew services stop mysql，返回 Warning: Service `mysql` is not started.

【MySql账密错误】
那么开启服务。
如果密码有误，则报错：ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)
```

## 查询本机的MySql的版本号，以及用什么容器进行下载管理

```bash
MySQL --version
```

## 查询本机的MySql的安装路径
```bash
whereis mysql
```

## 查询本机的MySql的PID

```bash
lsof -nP -i | grep mysql   

👆🏻能和"活动监视器"的数据对得上
```

## `mysql`与`mysqld`的区别

```
mysqld 是服务端程序
mysql是命令行客户端程序
```

## 关闭`mysqld`进程

```
mysqld的守护进程mysqld_safe,也是mysqld的父进程（守护进程）
```

## 找出MySql的全部用户

```javascript
资料来源：
MySql显示用户:列出所有用户 https://www.yiibai.com/mysql/show-users.html
```

## 更改 MySql 数据库用户名

```mysql
MySQL -u root -p
Enter password：***
MySQL> use MySQL;  选择数据库
Database changed
MySQL> update user set user="新用户名" where user="root";    将用户名为root的改为新用户名
MySQL> flush privileges;    // 刷新权限【一定要这一步，否则不成功】
MySQL> exit
```

## 语法提示且高亮

```bash
brew install mycli
```

```mysql
用户名：Jobs
数据库名字：db_book

mycli -u Jobs -h localhost -p password --database db_book
```

```
以这一种方式进入，既有语法提示，且高亮

但是以这一种方式运行 show 命令，会在另外的界面进行展示结果，按q退出
```


## 卸载删除MySql

```javascript
资料来源：
https://newsn.net/say/brew-uninstall-mysql.html
```

【用brew管理】

```bash
brew remove mysql 
```

或者 

```bash
brew uninstall mysql
```

```bash
brew cleanup
```

```mysql
sudo rm /usr/local/MySQL
sudo rm -rf /usr/local/MySQL*
sudo rm -rf /Library/StartupItems/MySQLCOM
sudo rm -rf /Library/PreferencePanes/My*
edit /etc/hostconfig and remove the line MySQLCOM=-YES-
rm -rf ~/Library/PreferencePanes/My*
sudo rm -rf /Library/Recipts/MySQL*
sudo rm -rf /Library/Receipts/MySQL*
sudo rm -rf /private/var/db/receipts/MySQL*
sudo rm -rf /var/db/receipts/com.mysql.*
```

## MySql忘记密码

```javascript
资料来源
【MySql修改密码的3种方式】 http://c.biancheng.net/view/7152.html
【MySql修改root密码的4种方法】 https://blog.csdn.net/qq_33285112/article/details/78982766
【MySql root密码忘记，原来还有更优雅的解法！】https://www.cnblogs.com/ivictor/p/9243259.html
```

```mysql
1、关闭MySql服务
不同容器方式管理的Mysql，关闭的方式不一样

2、进入安全模式
sudo mysqld_safe --skip-grant-tables

注意：这个地方可能会提示错误 mysqld_safe A mysqld process already exists
解决方式：killall mysqld mysqld_safe，至少等待 10 秒，以便它干净地关闭
```

## MySql数据库的本地磁盘路径

```javascript
资料来源 
https://blog.csdn.net/haiross/article/details/51258991
```

## MySql的配置文件`my.cnf`

```bash
find / -name my.cnf
```



















