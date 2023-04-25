#!/bin/bash

<<'COMMENT'
    # 📌定位到桌面
    cd Desktop/
    echo "/Users/"${USER}"/Desktop"

    cp /private/etc/hosts /Users/jobs/Desktop/  
COMMENT

<<'COMMENT'
该脚本的工作目标

以 /etc/hosts 为例 
将 /etc/hosts 拷贝到系统桌面 
进行文件修改
复制回原路径，进行替换
COMMENT

# 读取键盘输入，回车结束监听记录
read -p "拖入需要修改的保护区文件:" filePath
## 文件全名（包含后缀名）
fileFullName=${filePath##*/}
## 文件的后缀名（只针对最右边的一个后缀名有效）
fileSuffixName=${filePath##*.}
## 文件的后缀名（多后缀名有效）
fileSuffixName2=${filePath#*.}
## 文件所在目录路径
folderPath=${filePath%/*}
## 文件所在文件夹名
folderName=${folderPath##*/}

# cp $filePath $"/Users/"${USER}"/Desktop"

## 判定路径不允许是桌面
if [ "$folderPath" = "/Users/"${USER}"/Desktop" ]; then
    # echo "Paths are equal."
    echo "桌面不允许执行此操作！"
else
    # echo "Paths are different."
    cp $filePath $"/Users/"${USER}"/Desktop"
fi




