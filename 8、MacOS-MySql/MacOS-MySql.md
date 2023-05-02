# MacOS（本机）- MySql

[toc]


## 1、多种方式安装和管理 MySql

### 1.1、用 brew 容器管理 MySql

```bash
brew install mysql // 安装mysql
brew uninstall mysql 或者 brew remove mysql // 卸载mysql
brew info mysql // mysql的安装信息

brew services restart mysql // 重启MySQL
brew services stop mysql // 关闭MySQL
brew services start mysql // 启动MySQL
```

```bash
(sudo) mysql.server stop // 关闭MySQL
(sudo) mysql.server start // 启动MySQL
(sudo) mysql.server restart // 重启MySQL
```

```bash
运行brew service start mysql 可以后台启动mysql
运行(sudo) mysql.server start 前台启动mysql
```

![](https://github.com/295060456/JobsGenesis/blob/main/8%E3%80%81MacOS-MySql/MacOS-MySql.pic/%E9%80%9A%E8%BF%87brew%E5%AE%89%E8%A3%85%E7%9A%84MySql%E7%9B%AE%E5%BD%95%E7%BB%93%E6%9E%84.jpg?raw=true)

### 1.2、从官网下载 MySql 直接安装在本机（未验证）

```javascript
open https://juejin.cn/post/6844903956305412104
```

### 1.3、用 `Macport`/`brew`/`MySql` 官网下载直接安装到本机的区别

```
	3.1、Macport 和 brew 作为容器管理着 MySql 的生命周期，那么对于 MySql 的服务开启\关闭、重启 等的命令方式不一样
	3.2、比如：如果直接在终端以官网下载部署到Mac系统这种方式的命令找出 MySql 的 pid ，对其进行kill -9 关闭是无效的（因为有中间过程值，关闭了又会被激活）
	3.3、关闭服务，即停止本机上任何对 MySql 的调用。MySql 的调用前提一定要激发其对外提供服务
	3.4、因为安全原因，MySql的某些版本对于忘记密码的操作不一样，也就是说可能都不存在教程上的文件和路径
```

### 1.4、关于版本号

```bash
  4.1、MySql 忽然从5.7升级到了8.0，直接跳过了6和7。即，版本号码：5.5/5.6/5.7/8.0
  4.2、MySql-8.0 以前的版本需要使用命令'brew link',不主动link的话，连mysql命令行都不能使用。即使能使用mysql命令行的话，也是会提示不能登陆，缺少caching_sha2_password.so文件。
  无奈之下，就只能选择清理 MySql 了。

  以MySql-5.7版本为例，即：

  brew install mysql@5.7
  brew link mysql@5.7 --force
  brew services start mysql@5.7
  mysql -uroot -p
```

## 2、MySql 登录报错分析

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

## 3、查询本机的 MySql 的版本号，以及用什么容器进行下载管理

```bash
mysql --version
```

## 4、查询本机的 MySql 的安装路径

```bash
whereis mysql
```

## 5、查询本机的 MySql 的 PID

*👇🏻能和"活动监视器"的数据对得上*

```bash
lsof -nP -i | grep mysql   
```

## 6、`mysql`与`mysqld`的区别

```
mysqld 是服务端程序
mysql是命令行客户端程序
```

## 7、关闭`mysqld`进程

```
mysqld 的守护进程 mysqld_safe ,也是 mysqld 的父进程（守护进程）
```

## 8、找出 MySql 的全部用户

```javascript
资料来源

【MySql列出所有用户】
https://www.yiibai.com/mysql/show-users.html
```

## 9、更改 MySql 数据库用户名

```mysql
MySQL -u root -p
Enter password：***
MySQL> use MySQL;  选择数据库
Database changed
MySQL> update user set user="新用户名" where user="root";    将用户名为root的改为新用户名
MySQL> flush privileges;    // 刷新权限【一定要这一步，否则不成功】
MySQL> exit
```

## 10、语法提示且高亮

*以这一种方式进入，既有语法提示，且高亮*

*但是以这一种方式运行 show 命令，会在另外的界面进行展示结果，按q退出*

```bash
brew install mycli
```

```mysql
用户名：Jobs
数据库名字：db_book

mycli -u Jobs -h localhost -p password --database db_book
```

## 11、卸载删除 MySql

```javascript
资料来源

【如何清理 brew 安装的 mysql ？mysql 的数据文件在哪里？】
https://newsn.net/say/brew-uninstall-mysql.html
```

*用 brew 管理*

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

*直接安装在 MacOS 上，清除残留*

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

## 12、MySql 密码

### 12.1、MySql 忘记密码

```javascript
资料来源

【MySql修改密码的3种方式】 http://c.biancheng.net/view/7152.html
【MySql修改root密码的4种方法】 https://blog.csdn.net/qq_33285112/article/details/78982766
【MySql root密码忘记，原来还有更优雅的解法！】https://www.cnblogs.com/ivictor/p/9243259.html
```

*大体思路*

```mysql
12.1.1、关闭 MySql 服务
不同容器方式管理的Mysql，关闭的方式不一样
brew services stop mysql,或者 
(sudo) mysql.server stop

12.1.2、进入安全模式
sudo mysqld_safe --skip-grant-tables

注意：这个地方可能会提示错误 mysqld_safe A mysqld process already exists
解决方式：killall mysqld mysqld_safe，至少等待 10 秒，以便它干净地关闭
```

### 12.2、通过修改 MySql 的配置文件`my.cnf`来修改密码❤️

```javascript
资料来源

【忘记 mysql root用户密码的解决办法（skip-grant-tables）】https://blog.csdn.net/lxpbs8851/article/details/10895085
```

**`mysql` 的安装目录👇🏻**

```bash
brew list mysql
```

```bash
/opt/homebrew/Cellar/mysql
```

**按照`.brew/mysql.rb`的配置逻辑，修改my.cnf，并使其生效**

![](https://github.com/295060456/JobsGenesis/blob/main/8%E3%80%81MacOS-MySql/MacOS-MySql.pic/%E5%85%B3%E4%BA%8E.brew:mysql.rb.jpg?raw=true)

**`.bottle`是隐藏文件夹，其名下的`/etc/my.cnf`为mysql 配置文件**

**编辑`.bottle/etc/my.cnf`，在其末尾增添一句话：`skip-grant-tables`**

**复制`.bottle/etc/my.cnf  `→ `/etc  `**

```bash
cp /opt/homebrew/Cellar/mysql/8.0.32/.bottle/etc/my.cnf /etc  
```

![](https://github.com/295060456/JobsGenesis/blob/main/8%E3%80%81MacOS-MySql/MacOS-MySql.pic/%E4%BD%BF%E5%BE%97my.cnf%E7%94%9F%E6%95%88.jpg?raw=true)

**重启 `mysql`**

```mysql
mysql.server restart
```

**🎉🍺进入 `root` 用户（无密码）🎉🍺**

```mysql
➜  mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 7
Server version: 8.0.32 Homebrew

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
```

### 12.3、MySql 无密码状态的密码设置

```javascript
参考资料

https://cloud.tencent.com/developer/article/2097188
```

*无密码状态，不能用任何客户端链接成功*

```
(sudo) mysql_secure_installation
Aass1122
```

## 13、查看 MySql 数据库物理文件存放位置

```javascript
资料来源

https://blog.csdn.net/haiross/article/details/51258991
```

```mysql
mysql> show global variables like "%datadir%" ;  
+---------------+--------------------------+
| Variable_name | Value          |
+---------------+--------------------------+
| datadir    | /opt/homebrew/var/mysql/ |
+---------------+--------------------------+

1 row in set (0.02 sec)
```

## 14、命令行建库（test_jobs）建表（user_time_login_stat）

```mysql
mysql> CREATE TABLE user_time_login_stat ( id int NOT NULL AUTO_INCREMENT,  PRIMARY KEY (id)) ;

Query OK, 0 rows affected (0.01 sec)
```

*数据库本地化文件路径地址*

```javascript
/opt/homebrew/var/mysql/test_jobs/user_time_login_stat.ibd
```

## 15、MySql 日志

```javascript
资料来源

https://blog.csdn.net/Kirito_j/article/details/82714515
```

### 15.1、Mysql 有以下几种日志👇🏻

| 错误日志   |     -log-err      |
| :--------- | :---------------: |
| 查询日志   |       -log        |
| 慢查询日志 | -log-slow-queries |
| 更新日志   |    -log-update    |
| 二进制日志 |     -log-bin      |

### 15.2、日志的查询

*查看日志*

```mysql
mysql>SHOW VARIABLES LIKE "general_log%";
```

*启用日志*

```mysql
mysql>SET GLOBAL general_log = 'ON';
```

*是否启用了日志*

```mysql
mysql>show variables like 'log_%'; 
```

*怎样知道当前的日志*

```mysql
mysql> show master status; 
```

*显示二进制日志数目*

```mysql
mysql> show master logs; 
```

## 16、MySql 和 Shell 命令的互相调用

```javascript
资料来源

https://blog.csdn.net/chengyuqiang/article/details/121340775
https://blog.csdn.net/wocjj/article/details/7459033
```

### 16.1、在 Shell 中执行 MySql 相关查询

*通过参数-e*

```mysql
mysql -uroot -p -e "show databases"
```

### 16.2、在 MySql 命令行中执行 Shell 相关命令

*system + 系统shell命令（不需要分号） 或者 `\! 系统shell命令`*

```mysql
mysql> system date
mysql> system pwd
```

### 16.3、MySql 执行外部`x.sql`

*关键词：`source`*

```mysql
mysql> source /Users/jobs/Desktop/test.sql 
```

## 17、命令行使用 MySql

*说明：此例中存在一个名为`test`的数据库，库下面存在一张名为`user`的表*

```sql
CREATE database test;
CREATE TABLE IF NOT EXISTS `test`.`user` (
 `user_id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户编号',
 `user_name` VARCHAR(45) NOT NULL COMMENT '用户名称',
 `user_age` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户年龄',
 `user_sex` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户性别',
 PRIMARY KEY (`user_id`))
 ENGINE = InnoDB
 AUTO_INCREMENT = 1
 DEFAULT CHARACTER SET = utf8
 COLLATE = utf8_general_ci
 COMMENT = '用户表'
```

```
mysql -uroot -p //进入数据库命令行
create database go_db //创建名为go_db的数据库
use go_db //使用数据库
create table user_tbl//创建一个名为user_tbl的表

CREATE TABLE user_tbl (
     student_id int primary key, 
     student_name varchar(25), 
     student_age int, 
     gender char (1), 
     DOA date, 
     city_name varchar(20)
)
```

*显示所有的数据库（注意：`databases` 是复数末尾要加`s`）* **关键词`show`**

```mysql
mysql> show databases;
```

*删除名为`test`的数据库*  **关键词`drop`**

```mysql
mysql> drop test database;
```

*创建名为`test`的数据库*  **关键词`create`**

```mysql
mysql> create database test;
```

*使用用名为`test`的数据库（可以不用 `;`结尾）* **关键词`use`**

```mysql
use test;
```

*查看数据库`test`名下有什么表（当前只有一张名为`user`的表）* **关键词`show`**

```mysql
show tables;

mysql> show tables;
+----------------+
| Tables_in_test |
+----------------+
| user           |
+----------------+
1 row in set (0.00 sec)
```

*查看数据表`user`的表结构*   **关键词`describe`**

```mysql
mysql> describe user;
+-----------+------------------+------+-----+---------+----------------+
| Field     | Type             | Null | Key | Default | Extra          |
+-----------+------------------+------+-----+---------+----------------+
| user_id   | int unsigned     | NO   | PRI | NULL    | auto_increment |
| user_name | varchar(45)      | NO   |     | NULL    |                |
| user_age  | tinyint unsigned | NO   |     | 0       |                |
| user_sex  | tinyint unsigned | NO   |     | 0       |                |
+-----------+------------------+------+-----+---------+----------------+
4 rows in set (0.01 sec)
```







