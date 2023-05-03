# Mac zshrc文件找不到问题

[toc]

- [Mac zshrc文件找不到问题](#mac-zshrc文件找不到问题)
  - [1、创建zshrc](#1创建zshrc)
  - [2、打开zshrc](#2打开zshrc)
  - [3、同步继承系统配置](#3同步继承系统配置)
  - [4、刷新环境](#4刷新环境)

## 1、创建zshrc

```
touch .zshrc
```

## 2、打开zshrc

```
open -e .zshrc
```

## 3、同步继承系统配置

在zshrc文件里输入 source ~/.bash_profile，然后保存

```
source ~/.bash_profile
```

## 4、刷新环境

```
source .zshrc
```



