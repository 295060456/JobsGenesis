# 关于Mac OS的一些常用基本命令



## 查看本机内网IP

➜ **~** ifconfig | grep "inet "

​	**inet** 127.0.0.1 netmask 0xff000000 

​	**inet** 192.168.1.243 netmask 0xffffff00 broadcast 192.168.1.255

​	**inet** 192.168.2.1 netmask 0xffffff00 broadcast 192.168.2.255

## 查看本机公网IP

curl [ifconfig.me](http://ifconfig.me)

curl ipinfo.io/json 

## 查看一个域名（百度）的IP

nslookup www.baidu.com

## Mac修改hosts文件并使其立即生效

sudo killall -HUP mDNSResponder

## Mac查看命令位置（以nginx为例）

whereis nginx