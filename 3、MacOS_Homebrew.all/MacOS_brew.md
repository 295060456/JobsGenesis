#  MacOS_brew

[toc]

## 本地文件的下载地址

```shell
➜  ~ open /Users/jobs/Library/Caches/Homebrew/downloads/
```

```bash
➜  ~ brew services list
Warning: Calling plist_options is deprecated! Use service.require_root instead.
Please report this issue to the elastic/tap tap (not Homebrew/brew or Homebrew/homebrew-core), or even better, submit a PR to fix it:
  /opt/homebrew/Library/Taps/elastic/homebrew-tap/Formula/elasticsearch-full.rb:68

Name               Status     User File
elasticsearch-full none            
httpd              started    jobs ~/Library/LaunchAgents/homebrew.mxcl.httpd.plist
lighttpd           none            
mongodb-community  error  512 jobs ~/Library/LaunchAgents/homebrew.mxcl.mongodb-community.plist
mysql              started    jobs ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
nginx              none            
php                none            
tomcat             none            
unbound            none   
```



```
brew list           列出已安装的软件
brew update     更新brew
brew home       用浏览器打开brew的官方网站
brew info         显示软件信息
brew deps        显示包依赖
```

