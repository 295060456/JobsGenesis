# MacOS 配置 Golang 环境

[toc]

```javascript
资料来源
https://www.jianshu.com/p/7f9f73327fd8
```

## 检查 golang 的安装位置

### 1、直接安装到系统的

```
➜  ~ whereis go
go: /usr/local/go
```

### 2、通过 brew 安装的（推荐）

```
➜  ~ whereis go
go: /opt/homebrew/bin/go
```

## 安装 Golang 环境

### 1、Golang API

1.1、直接安装到系统的。根据自我具体机型进行选择安装方案

`open https://go.dev/dl/`

1.2、通过 brew 安装的（推荐）

`brew install go`

### 2、vscode 中 Go 的相关插件安装

2.1、进入 golang 目录

`cd $GOPATH/src/github.com/golang`，如果没有目录就手动创建

2.2、下载插件

`git clone https://github.com/golang/tools.git tools`

## 配置 GOPATH

```
资料来源
https://www.topgoer.com/%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83/%E9%85%8D%E7%BD%AEgopath.html
```

### GOPATH 目录说明

![](https://www.topgoer.com/static/2/4.png)

### GOPATH目前流行的项目结构

![](https://www.topgoer.com/static/2/6.png)

### 适合个人开发者的目录结构

![](https://www.topgoer.com/static/2/5.png)

### 适合企业开发者的目录结构

![](https://www.topgoer.com/static/2/7.png)

## 删除 Golang 环境

```javascript
资料来源
https://blog.csdn.net/weixin_36908494/article/details/126096277
```

### 1、【删除】直接安装到系统的

1.1、删除 go 目录，通常为目录 /usr/local/go

`sudo rm -rf /usr/local/go`

`sudo rm -rf ${HOME}/go`

1.2、从 PATH 环境变量中移除 Go 的 bin 目录

PATH 配置在 `$~/.bash_profile` 或者` /etc/profile`，根据实际情况删除

1.3、如果是通过Mac OS X 包安装的 Go，还需要移除` /etc/paths.d/go` 文件

`sudo rm -rf /etc/paths.d/go`

1.4 、使得配置文件生效

`source ~/.bash_profile`

1.5、删除GOPATH目录



### 2、【删除】通过 brew 安装的

`brew uninstall go`

