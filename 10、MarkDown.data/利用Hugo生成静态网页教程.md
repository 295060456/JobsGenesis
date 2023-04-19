# 利用Hugo生成静态网页教程

[toc]

## 资料来源

```javascript
https://www.gohugo.org/
```

## 环境配置

使用终端：Oh-My-Zsh

## 利用brew自动配置安装Hugo（其他方式不推荐）

```bash
brew install hugo
```

## 生成站点

### 1、前置条件：

​	1.1、桌面建立一个空文件夹（Test_Hugo），用于存放静态网页文件相关资源以及依赖

​	1.2、拖动Test_Hugo到终端，执行：hugo new site 【拖动‘Test_Hugo’文件夹到终端】，此时文件夹Test_Hugo里面生成内容如下图所示👇🏻

![image-20230403235709736](/Users/jobs/Library/Application Support/typora-user-images/image-20230403235709736.png)

### 2、创建一些页面资源

```bash
	2.1、【创建文章页面】 hugo new about.md
	2.2、【创建第一篇文章，放到 `post` 目录，方便之后生成聚合页面】 hugo new post/first.md
```

### 3、安装皮肤

​	cd命令进入themes文件夹，执行命令

```javascript
git clone https://github.com/spf13/hyde.git
```

## 运行Hugo

### 1、本地运行

跳出themes文件目录，并且回到Test_Hugo目录，执行命令：

```bash
hugo server --theme=hyde --buildDrafts
```

![image-20230404000715846](/Users/jobs/Library/Application Support/typora-user-images/image-20230404000715846.png)

此时，页面服务（监听默认端口1313）已经开启，可以在浏览器里面进行访问

```javascript
http://localhost:1313
```

注意：只要关闭Mac终端或者Ctrl+C，都会结束掉页面服务，导致 http://localhost:1313 无法打开

### 2、远程发布到GitHub

1、首先在GitHub上创建一个Repository，命名为：`295060456.github.io` （295060456替换为你的github用户名）

2、回到Test_Hugo目录，运行：

```
hugo --theme=hyde --baseUrl="http://coderzh.github.io/"
```

此时"public"目录下生成一些文件，如下图所示👇🏻：

![image-20230404015126775](/Users/jobs/Library/Application Support/typora-user-images/image-20230404015126775.png)

3、按照Github官方的解释，这个时候要确保：

在该项目文件夹下面→Setting→（左侧边栏）Code and automation→GitHub Pages

![image-20230404015444441](/Users/jobs/Library/Application Support/typora-user-images/image-20230404015444441.png)



可能需要等待几分钟，这个时候访问浏览器：https://295060456.github.io/ 🍺成功🍺