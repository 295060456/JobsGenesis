# Shell实用代码块

[toc]

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

```javascript
资料来源
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

## 在 MacOS 终端里面，获取当前用户路径

${HOME}

```
➜  Shell 学习 ${HOME}                         
➜  ~ 
➜  ~ echo ${HOME}                    
/Users/jobs
➜  ~ 
```

## 在Shell脚本里面，获取当前用户路径

### 1、打印出当前的用户名（注意：这里是双引号）

```
echo "$USER"
```

或者

```
echo `whoami`
```

### 2、打印出当前的用户进程ID

```
echo "$UID"
```

或者

```
echo `id -u`
```

### 3、 打印出当前用户的详细信息（排列板式不一）

```
echo `who am i`
```

或者

```
echo `who` 
```

或者

```
who
```

### 4、打印当前终端所指向的路径

```
CRTDIR=$(pwd)
echo $CRTDIR
```

### 5、打印当前执行的脚本文件的父目录

```
workdir=$(cd $(dirname $0); pwd)
echo $workdir
```

或者

```
PRG="$0"
while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
PRGDIR=$(cd $(dirname $PRG); pwd)
echo $PRGDIR
```

### 6、参数的获取

```
资料来源
https://segmentfault.com/a/1190000021435389
```

#### 6.1、假设执行 `./test.sh a b c` 这样一个命令，则可以使用下面的参数来获取一些值：

```
$0
对应 *./test.sh* 这个值。如果执行的是 ./work/test.sh， 则对应 *./work/test.sh* 这个值，而不是只返回文件名本身的部分
```

```
$1
会获取到 a，即 "$1" 对应传给脚本的第一个参数
```

```
$2
会获取到 b，即 "$2" 对应传给脚本的第二个参数
```

```
$3
会获取到 c，即 "$3" 对应传给脚本的第三个参数。"$4"、"$5" 等参数的含义依此类推
```

```
$#
会获取到 3，对应传入脚本的参数个数，统计的参数不包括 "$0"
```

```
$@
会获取到 "a" "b" "c"，也就是所有参数的列表，不包括 "$0"
```

```
$*
也会获取到 "a" "b" "c"， 其值和 "$@" 相同。但 "$*" 和 "$@" 有所不同
"$*" 把所有参数合并成一个字符串，而 "$@" 会得到一个字符串参数数组
```

```
$?
可以获取到执行 ./test.sh a b c 命令后的返回值
在执行一个前台命令后，可以立即用 "$?" 获取到该命令的返回值
该命令可以是系统自身的命令，可以是 shell 脚本，也可以是自定义的 bash 函数
当执行系统自身的命令时，"$?" 对应这个命令的返回值
当执行 shell 脚本时，"$?" 对应该脚本调用 exit 命令返回的值。如果没有主动调用 exit 命令，默认返回为 0
当执行自定义的 bash 函数时，"$?" 对应该函数调用 return 命令返回的值。如果没有主动调用 return 命令，默认返回为 0
```

```
$$
shell脚本的进程号
```

#### 6.2、举例说明 `"$*"` 和 `"$@"` 的差异

假设有一个 `testparams.sh` 脚本，内容如下：

```bash
#!/bin/bash

for arg in "$*"; do
    echo "****:" $arg
done
echo --------------
for arg in "$@"; do
    echo "@@@@:" $arg
done
```

这个脚本分别遍历 `"$*"` 和 `"$@"` 扩展后的内容，并打印出来。

执行 `./testparams.sh` 脚本，结果如下：

```
$ ./testparams.sh This is a test
****: This is a test
--------------
@@@@: This
@@@@: is
@@@@: a
@@@@: test
```

可以看到，`"$*"` 只产生一个字符串，for 循环只遍历一次。
而 `"$@"` 产生了多个字符串，for 循环遍历多次，是一个字符串参数数组。



**注意**：如果传入的参数多于 9 个，则不能使用 `$10` 来引用第 10 个参数，而是要用 `${10}` 来引用。

即，需要用大括号`{}`把大于 9 的数字括起来。
例如，`${10}` 表示获取第 10 个参数的值，写为 `$10` 获取不到第 10 个参数的值。
实际上，`$10` 相当于 `${1}0`，也就是先获取 `$1` 的值

#### 6.3、获取位置参数的个数

在 bash 中，可以使用 `$#` 来获取传入的命令行或者传入函数的参数个数。
要注意的是，`$#` 统计的参数个数不包括脚本自身名称或者函数名称。
例如，执行 `./a.sh a b`，则 `$#` 是 2，而不是 3。

可以看到，`$#` 实际上是扩展为位置参数（positional parameters）的个数，统计的参数不包括 `$0`。















































