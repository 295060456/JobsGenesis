# Shell实用代码块

- [Shell实用代码块](#shell实用代码块)
  - [用 Visual Studio Code 作为IDE编辑代码](#用-visual-studio-code-作为ide编辑代码)
  - [第一行固定写法](#第一行固定写法)
  - [加权限(当前用户的执行权限)](#加权限当前用户的执行权限)
  - [关于路径](#关于路径)
  - [键盘监听](#键盘监听)
  - [if/else举例](#ifelse举例)
  - [for/in 和 do/done举例](#forin-和-dodone举例)
  - [多行注释](#多行注释)
  - [添加定义](#添加定义)
  - [添加默认值（字符串）](#添加默认值字符串)
  - [清空文件（localGoEnvInfo.md）](#清空文件localgoenvinfomd)
  - [向文件写内容(一段内容)](#向文件写内容一段内容)
  - [向文件写内容(一行内容)](#向文件写内容一行内容)
  - [在列表里面（gem list --local）搜寻（grep）文本（cocoapods）](#在列表里面gem-list---local搜寻grep文本cocoapods)

## 用 Visual Studio Code 作为IDE编辑代码

```shell
code .
```

## 第一行固定写法

```shell
#!/bin/bash
```

## 加权限(当前用户的执行权限)

资料来源

```javascript
https://www.jianshu.com/p/d11f2c49921b
```

```
u 代表用户;
g 代表用户组;
o 代表其他;
a 代表所有;
```

```
-: 代表无权限;
r: 代表可读权限;
w: 代表可写权限;
x: 代表可执行权限;
```

```shell
# 如果没有执行权限，在这个sh文件的目录下，执行chmod u+x *.sh
filePath=$(dirname $0)/$(basename $0)
echo "我在这里：$filePath" 

# 定位📌于该文件的垂直文件夹
folderPath=$(dirname $0)
cd folderPath

# 加权限（给当前用户加执行权限）
fileFullName=$(basename $0)
chmod u+x $fileFullName
```

## 关于路径

```javascript
资料来源
https://blog.csdn.net/LGD_2008/article/details/45913957

echo "$(basename $0) $(dirname $0) -- $filepath " 
脚本文件的绝对路径存在了环境变量filepath中，可以用echo $filepath  

$0: 获取当前脚本的名称 
$#: 传递给脚本的参数个数 
$$: shell脚本的进程号
```

获取该sh文件的绝对路径

```shell
echo "$(dirname $0)/$(basename $0)" 
```

获取该sh文件所在目录的绝对路径

```shell
filepath=$(cd "$(dirname "$0")"; pwd)
```

## 键盘监听

```shell
read -p "请输入项目文件夹名字,以回车结束:" folder_name
defaultInput $folder_name
# echo "The value of var is ${defaultInput}"
```

```shell
# 把键盘输入放入变量sure
read sure
```

## if/else举例

读取判定键盘输入的字符是否为回车

```shell
if [[ $sure = "" ]];then

else
    
fi
```

判定命令行对外输出字符

```shell
if brew -v;then
    echo "The package is installed"
    brew update
    brew doctor
    brew -v
else
    echo "The package is not installed"
    open https://brew.sh/
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ### brew环境变量设置
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
```

## for/in 和 do/done举例

```shell
for element in `gem list --local | grep cocoapods`
    do
        echo $"正在卸载CocoaPods子模块："$element$"......"
        # 使用命令逐个删除
        sudo gem uninstall $element
    done
else
    echo "取消卸载CocoaPods"
fi
```

## 多行注释

## 添加定义

```shell
<<'COMMENT'
Hi
COMMENT
```

## 添加默认值（字符串）

```shell
function defaultInput() {
	result=${1}
	if [${1} = $""]
	then
		# 什么都不输入，即默认值
		result=$'Test'
	fi
}
```

## 清空文件（localGoEnvInfo.md）

```shell
echo "" > localGoEnvInfo.md
```

## 向文件写内容(一段内容)

```shell
cat>$file_name<<EOF
// 你想写入的内容
EOF
```

## 向文件写内容(一行内容)

```
全局搜索文件（ ~/.bash_profile），
进行文件内查找字符串（GOPATH），
并对其进行写入（export PATH="$GOPATH/bin:$PATH"），并刷新配置

【唯一性】
```

```shell
grep GOPATH ~/.bash_profile
if [ $? -ne 0 ] ;then
	echo 'export PATH="$GOPATH/bin:$PATH"' >> ~/.bash_profile
	source ~/.bash_profile
fi
```

## 在列表里面（gem list --local）搜寻（grep）文本（cocoapods）

```shell
echo "查看本地安装过的cocopods相关东西"
gem list --local | grep cocoapods
```
