#!/bin/bash

<<'COMMENT'
if ["$folder_name" = ""]
then
    # 什么都不输入，即默认值
    folder_name="Test"
fi
COMMENT

# 定义一些基本的函数
# 添加默认值（字符串）
function defaultInput() {
    result=${1}
    if [${1} = $""]
    then
        # 什么都不输入，即默认值
        result=$'Test'
    fi  
}
# ❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️
# 📌定位到桌面
cd Desktop/
# 先定义项目文件夹
printf '【自动化前置部署Go项目】\n\n'
# 读取键盘输入，回车结束监听记录
echo "【温馨提示：如果什么都没有输入，那么启用默认文件夹名Test】"
read -p "请输入项目文件夹名字,以回车结束:" folder_name

defaultInput $folder_name
folder_name=${result}
# echo "The value of var is ${result}"

mkdir ${folder_name}
echo -n "已经在桌面建立一个名为:${folder_name}的文件夹，并打开他"
open ${folder_name} 
# 📌定位到刚才创立的项目文件夹
cd ${folder_name}
# 用mod管理项目
<<'COMMENT'
go.mod文件一旦创建后，它的内容将会被go toolchain全面掌控。
go toolchain会在各类命令执行时，比如go get、go build、go mod等修改和维护go.mod文件。
COMMENT
go mod init gone

# 用Visual Studio Code作为IDE编辑代码[可以放在最后]
code .

# 读取键盘输入，回车结束监听记录
echo "【温馨提示：如果什么都没有输入，那么启用默认文件名Test】"
read -p "请输入新建文件名字，以回车结束:" file_name

defaultInput $file_name
file_name=${result}
# echo "The value of var is ${result}"

# 新建一个文件，命名为Test
file_name=$file_name$".go"
Touch $file_name

# 写内容到文件🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛
cat>$file_name<<EOF

package main

import (
    "github.com/gin-gonic/gin"
)

func main() {
    r := gin.Default()
    r.GET("/ping", func(c *gin.Context) {
        c.JSON(200, gin.H{
            "message": "pong",
        })
    })
    r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}

EOF
#🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛🌛

# 下载依赖
go run $file_name

# 依赖下载完成，会生成go.sum文件

# 生成一些配置说明文件
## 先清空
echo "" > localGoEnvInfo.md
## 再写入
echo "【❤️golang的环境配置】" >> localGoEnvInfo.md
go env >> localGoEnvInfo.md
echo "【❤️OS的环境变量】" >> localGoEnvInfo.md
sed 's/:/\n/g' <<< "$PATH" >> localGoEnvInfo.md
open localGoEnvInfo.md


# vendor目录
## 安装govendor
go get -u -v github.com/kardianos/govendor
## 检查是否安装成功
govendor -version

# 写入环境变量
## 在~/.bash_profile文件内部搜索是否包含GOPATH（全匹配：包括大小写和文字）
<<'COMMENT'
grep返回的退出状态为0，表示成功。 
退出状态为1，表示没有找到。 
如果找不到指定的文件，退出状态为2
COMMENT

<<'COMMENT'
大于 -gt (greater than)
小于 -lt (less than)
大于或等于 -ge (greater than or equal)
小于或等于 -le (less than or equal)
不相等 -ne （not equal）
相等 -eq （equal）
COMMENT
# 搜索不成功，说明还没有被写入，则写入【防止过度写入】
# 配置文件更新以后不会自动刷新UI，需要重新open，才可以看到实时数据
grep GOPATH ~/.bash_profile
if [ $? -ne 0 ] ;then
    echo 'export PATH="$GOPATH/bin:$PATH"' >> ~/.bash_profile
    source ~/.bash_profile
fi

grep GOPATH ~/.zshrc
if [ $? -ne 0 ] ;then
    echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.zshrc
    source ~/.zshrc
fi




