#!/bin/bash

echo '关闭本机通过 brew 方式安装的 MySql 服务'
brew services stop mysql
mysql.server stop
echo '彻底删除本机通过 brew 方式安装的 MySql'
brew uninstall mysql
# brew cleanup
echo '本机重新通过 brew 形式安装 MySql'
brew install mysql
echo '本机通过 brew 形式安装的 MySql 安装目录'
brew list mysql
# 不出意外，会对外输出 /opt/homebrew/Cellar/mysql
mysql --version

read -p "请输入本机的 Mysql 版本号，以回车结束。默认8.0.32:" mysqlVersion
if [[ $sure = "" ]];then
    mysqlVersion="8.0.32"
fi
fileCopy_fullname=$"/opt/homebrew/Cellar/mysql/"${mysqlVersion}"/.bottle/etc/my.cnf"
echo "fileCopy_fullname:"$fileCopy_fullname
grep skip-grant-tables $fileCopy_fullname
if [ $? -ne 0 ] ;then
cat>>${fileCopy_fullname}<<EOF
skip-grant-tables
EOF
fi

sudo cp $fileCopy_fullname /etc/my.cnf