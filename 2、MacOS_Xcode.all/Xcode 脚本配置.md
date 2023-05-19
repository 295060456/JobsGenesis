# Xcode 脚本配置

[toc]
- [Xcode 脚本配置](#xcode-脚本配置)
  - [1、相关准备](#1相关准备)
  - [2、如果是Debug环境并且目录存在开始打包](#2如果是debug环境并且目录存在开始打包)
  - [3、打开app目录](#3打开app目录)
  - [4、如果Payload存在, 删除Payload避免新建文件夹失败](#4如果payload存在-删除payload避免新建文件夹失败)
  - [5、创建Payload文件夹](#5创建payload文件夹)
  - [6、拷贝app到Payload](#6拷贝app到payload)
  - [7、打包成ipa](#7打包成ipa)
  - [8、打开当前目录](#8打开当前目录)
*资料来源*

[简书/iOS快速打包(仅限提测使用)](https://www.jianshu.com/p/d1e7dd688df7)

## 1、相关准备

```
1、定位于项目中xxx.xcodeproj
2、Target->build phases->点击左上角”＋“号->New Run Script phase
3、在下列Run Script里面输入：
```

## 2、如果是Debug环境并且目录存在开始打包

```shell
if [ "${CONFIGURATION}" = "Debug" ] && [ -d "${BUILD_ROOT}/${CONFIGURATION}-iphoneos" ]
then
```

## 3、打开app目录

```bash
cd ${BUILD_ROOT}/${CONFIGURATION}-iphoneos
```

## 4、如果Payload存在, 删除Payload避免新建文件夹失败

```shell
if [ -d "Payload" ]
then
rm -rf Payload
echo "Payload已存在并移除完毕!"
fi
```

## 5、创建Payload文件夹

```bash
mkdir Payload
```

## 6、拷贝app到Payload

```bash
cp -rf ${PROJECT_NAME}.app Payload
```

## 7、打包成ipa

```bash
zip -r ${PROJECT_NAME}.ipa Payload
```

## 8、打开当前目录

```bash
open .
```



