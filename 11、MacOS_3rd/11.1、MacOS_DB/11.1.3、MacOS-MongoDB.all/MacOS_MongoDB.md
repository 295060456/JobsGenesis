# MacOS_MongoDB

[toc]

```javascript
资料来源

https://www.toutiao.com/article/7199175994111033871/?tt_from=copy_link&utm_campaign=client_share&app=news_article&utm_source=copy_link&iid=424846500052268&utm_medium=toutiao_ios&use_new_style=1&share_token=68F663DD-D220-4190-9013-E541DEEABF55
```

## 1、简介

```json
MongoDB 是由C++语言编写的，是一个基于分布式文件存储的开源数据库系统
MongoDB 将数据存储为一个文档，数据结构由键值(key=>value)对组成
MongoDB 文档类似于 JSON 对象
字段值可以包含其他文档，数组及文档数组
举例：
{
	name:"sue",
	age:26,
	status:"A",
	groups:["new","sport"]
}
```

## 2、安装

```javascript
资料来源

https://www.runoob.com/mongodb/mongodb-osx-install.html
https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-os-x/
https://github.com/gcollazo/mongodbapp
https://juejin.cn/post/7069566026655989767
```

### 2.1、使用 Homebrew 安装 mongodb（废弃）

```bash
➜  ~ brew install mongodb
==> Downloading https://formulae.brew.sh/api/formula.jws.json
######################################################################### 100.0%
==> Downloading https://formulae.brew.sh/api/cask.jws.json
######################################################################### 100.0%
Warning: No available formula with the name "mongodb". Did you mean mongosh or monetdb?
==> Searching for similarly named formulae and casks...
==> Formulae
mongodb-atlas-cli
mongodb/brew/libmongocrypt
mongodb/brew/mongodb-community ✔
mongodb/brew/mongodb-community-shell
mongodb/brew/mongodb-community-shell@4.2
mongodb/brew/mongodb-community-shell@4.4
mongodb/brew/mongodb-community@4.2
mongodb/brew/mongodb-community@4.4
mongodb/brew/mongodb-community@5.0
mongodb/brew/mongodb-csfle
mongodb/brew/mongodb-database-tools ✔
mongodb/brew/mongodb-enterprise
mongodb/brew/mongodb-enterprise@4.2
mongodb/brew/mongodb-enterprise@4.4
mongodb/brew/mongodb-enterprise@5.0
mongodb/brew/mongodb-mongocryptd
mongodb/brew/mongodb-mongocryptd@4.2
mongodb/brew/mongodb-mongocryptd@4.4
mongodb/brew/mongodb-mongocryptd@5.0
mongosh ✔
monetdb

To install mongodb-atlas-cli, run:
  brew install mongodb-atlas-cli

==> Casks
gcollazo-mongodb ✔                       mongodb-realm-studio
mongodb-compass                          mongodbpreferencepane
mongodb-compass-isolated-edition         mongotron
mongodb-compass-readonly                 nosqlbooster-for-mongodb

To install gcollazo-mongodb ✔, run:
  brew install --cask gcollazo-mongodb ✔
```

### 2.1、使用 Homebrew Cask 安装 gcollazo-mongodb

```bash
➜  ~ brew reinstall --cask gcollazo-mongodb
==> Downloading https://github.com/gcollazo/mongodbapp/releases/download/6.0.0-b
==> Downloading from https://objects.githubusercontent.com/github-production-rel
######################################################################### 100.0%
==> Uninstalling Cask gcollazo-mongodb
==> Backing App 'MongoDB.app' up to '/opt/homebrew/Caskroom/gcollazo-mongodb/6.0
==> Removing App '/Applications/MongoDB.app'
==> Purging files for version 6.0.0-build.1 of Cask gcollazo-mongodb
==> Installing Cask gcollazo-mongodb
==> Moving App 'MongoDB.app' to '/Applications/MongoDB.app'
🍺  gcollazo-mongodb was successfully installed!
```

```bash
➜  ~ brew list gcollazo-mongodb       
==> App
/Applications/MongoDB.app (185 files, 224.7MB)
```

### 2.2、使用 Homebrew Cask 安装 MongoDB 6.0 Community Edition

```bash
➜  ~ brew reinstall mongodb-community
==> Fetching dependencies for mongodb/brew/mongodb-community: node@16 and mongosh
==> Fetching node@16
==> Downloading https://ghcr.io/v2/homebrew/core/node/16/manifests/16.20.0
######################################################################### 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/node/16/blobs/sha256:9a935f6418
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sh
######################################################################### 100.0%
==> Fetching mongosh
==> Downloading https://ghcr.io/v2/homebrew/core/mongosh/manifests/1.8.2
######################################################################### 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/mongosh/blobs/sha256:a097528d6a
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sh
######################################################################### 100.0%
==> Fetching mongodb/brew/mongodb-community
==> Downloading https://fastdl.mongodb.org/osx/mongodb-macos-arm64-6.0.5.tgz
######################################################################### 100.0%
==> Reinstalling mongodb/brew/mongodb-community 
Warning: Your Xcode (14.2) is outdated.
Please update to Xcode 14.3 (or delete it).
Xcode can be updated from the App Store.

==> Installing dependencies for mongodb/brew/mongodb-community: node@16 and mongosh
==> Installing mongodb/brew/mongodb-community dependency: node@16
==> Pouring node@16--16.20.0.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/node@16/16.20.0: 1,890 files, 47.5MB
==> Installing mongodb/brew/mongodb-community dependency: mongosh
==> Pouring mongosh--1.8.2.arm64_ventura.bottle.tar.gz
🍺  /opt/homebrew/Cellar/mongosh/1.8.2: 8,228 files, 40.8MB
==> Installing mongodb/brew/mongodb-community
==> Caveats
To restart mongodb/brew/mongodb-community after an upgrade:
  brew services restart mongodb/brew/mongodb-community
Or, if you don't want/need a background service you can just run:
  /opt/homebrew/opt/mongodb-community/bin/mongod --config /opt/homebrew/etc/mongod.conf
==> Summary
🍺  /opt/homebrew/Cellar/mongodb-community/6.0.5: 11 files, 200.5MB, built in 5 seconds
==> Running `brew cleanup mongodb-community`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
Warning: Calling plist_options is deprecated! Use service.require_root instead.
Please report this issue to the elastic/tap tap (not Homebrew/brew or Homebrew/homebrew-core), or even better, submit a PR to fix it:
  /opt/homebrew/Library/Taps/elastic/homebrew-tap/Formula/elasticsearch-full.rb:68

==> Caveats
==> mongodb-community
To restart mongodb/brew/mongodb-community after an upgrade:
  brew services restart mongodb/brew/mongodb-community
Or, if you don't want/need a background service you can just run:
  /opt/homebrew/opt/mongodb-community/bin/mongod --config /opt/homebrew/etc/mongod.conf
```

```bash
➜  ~ brew list mongodb-community                
/opt/homebrew/Cellar/mongodb-community/6.0.5/bin/install_compass
/opt/homebrew/Cellar/mongodb-community/6.0.5/bin/mongod
/opt/homebrew/Cellar/mongodb-community/6.0.5/bin/mongos
/opt/homebrew/Cellar/mongodb-community/6.0.5/homebrew.mongodb-community.service
/opt/homebrew/Cellar/mongodb-community/6.0.5/homebrew.mxcl.mongodb-community.plist
/opt/homebrew/Cellar/mongodb-community/6.0.5/MPL-2
/opt/homebrew/Cellar/mongodb-community/6.0.5/THIRD-PARTY-NOTICES
```

## 3、端口

`默认端口：27017`

