# Xcode 脚本配置

[toc]

## 1、资料来源

```
https://www.jianshu.com/p/d1e7dd688df7
```

## 2、相关准备

```
1、定位于项目中xxx.xcodeproj
2、Target->build phases->点击左上角”＋“号->New Run Script phase
3、在下列Run Script里面输入：
```

## 3、如果是Debug环境并且目录存在开始打包
```
if [ "${CONFIGURATION}" = "Debug" ] && [ -d "${BUILD_ROOT}/${CONFIGURATION}-iphoneos" ]
then
```

## 4、打开app目录
```
cd ${BUILD_ROOT}/${CONFIGURATION}-iphoneos
```

## 5、如果Payload存在, 删除Payload避免新建文件夹失败
```
if [ -d "Payload" ]
then
rm -rf Payload
echo "Payload已存在并移除完毕!"
fi
```

## 6、创建Payload文件夹
```
mkdir Payload
```

## 7、拷贝app到Payload
```
cp -rf ${PROJECT_NAME}.app Payload
```

## 8、打包成ipa
```
zip -r ${PROJECT_NAME}.ipa Payload
```

## 9、打开当前目录
```
open .
```



