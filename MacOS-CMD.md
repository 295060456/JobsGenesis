

# 关于MacOS的一些常用基本命令

## 【前言】

1、对于系统文件夹或文件，则需要在前输入sudo。sudo = super user do

2、mv = move，r = recursion（一般是“向下”递归），f = force（强制）

3、没有后缀名的文件 = 同名文件夹，两者不能同时存在于相同目录

## 1、返回上一级目录

```
cd ..
注：cd和..之间有空格，可以不止1个空格
```

## 2、MV命令

```
2.1、移动（该目录下）名字为sd的文件夹(哪怕文件夹不为空)，到系统回收站
mv sd ~/.Trash/
2.2、重命名文件（夹）
mv 需要修改的名称 修改后的名称
```

## 3、直接删除名字为sd的文件夹（包括此文件夹下面所有文件）不放入系统回收站

```
rm -r sd
如果不添加-r ，则会报警告 rm: sd: is a directory
```

## 4、创建文件（没有后缀名）：touch

```
4.1、如果该文件目录下已经存在一个同名文件
则不会被二次创建，也就意味着原文件将不会被覆盖
4.2、但是如果该文件目录下，已经存在一个文件A，再用mkdir创建同名目录，则创建失败，报错mkdir: sd:       File exists
4.3、如果已经存在一个名为sd的文件夹，则无法创建名字为sd的文件（无后缀名）
```

## 5、查看本机内网IP

```
ifconfig | grep "inet "
```

## 6、查看本机公网IP

```
1、open http://ifconfig.me
2、curl ifconfig.me
3、curl ipinfo.io/json 
```

## 7、查看一个域名（百度）的IP

```
nslookup www.baidu.com
```

## 8、修改hosts文件，并使其立即生效

```
sudo killall -HUP mDNSResponder
```

## 9、查看命令（软件）的安装位置（以nginx为例）

```
whereis nginx
```

## 10、查询本机的某活动软件的PID(以mysql为例)

```
能和"活动监视器"的数据对得上
lsof -nP -i | grep mysql  
```

## 11、获取所有进程完整信息(包括: UID、PID、PPID)

```
ps -le
```






























