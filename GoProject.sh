#!/bin/bash

# 📌定位到桌面
cd Desktop/
# 先定义项目文件夹
printf '【自动化前置部署Go项目】\n\n'
# 读取键盘输入，回车结束监听记录
read -p "请输入项目文件夹名字:" folder_name

if ["$folder_name" = ""]
then
    # 什么都不输入，即默认值
    folder_name="Test"
fi

# echo "The value of var is ${folder_name}"

mkdir ${folder_name}
echo -n "已经在桌面建立一个名为:${folder_name}的文件夹，并打开他"
open ${folder_name} 
# 📌定位到刚才创立的项目文件夹
cd ${folder_name}
# 用mod管理项目
go mod init gone

# 用Visual Studio Code作为IDE编辑代码[可以放在最后]
code .

# 读取键盘输入，回车结束监听记录
echo "请输入新建文件名字，以回车结束\n"
read -p "如果什么都没有输入，那么启用默认文件名：Test" file_name

if ["$file_name" = ""]
then
    # 什么都不输入，即默认值
    file_name="Test"
fi

# echo "The value of var is ${file_name}"

# 新建一个文件，命名为Test
$file_name=$file_name$".go"
Touch $file_name

# 写内容到文件
cat>$file_name<<EOF
package main

func main() {
	
}
EOF

