# !/bin/bash

echo '关闭本机通过 brew 方式安装的 MySql 服务'
brew services stop mysql
mysql.server stop

echo '本机通过 brew 形式安装的 MySql 安装目录'
brew list mysql
# 不出意外，会对外输出 /opt/homebrew/Cellar/mysql
mysql --version

read -p "请输入本机的 Mysql 版本号，以回车结束。默认8.0.32:" mysqlVersion
if [[ $mysqlVersion = "" ]];then
    mysqlVersion="8.0.32"
fi
fileCopy_fullname=$"/opt/homebrew/Cellar/mysql/"${mysqlVersion}"/.bottle/etc/my.cnf"
echo "fileCopy_fullname:"$fileCopy_fullname

# 直接追加写入
cat>>${fileCopy_fullname}<<EOF
# 这里写入需要修改的配置信息
gtid_mode=ON  
log-slave-updates=1  
enforce-gtid-consistency=1  
skip-grant-tables  

EOF

code $fileCopy_fullname
read -p "检查完毕并保存:通过brew管理的Mysql配置文件【my.cnf】" 
sudo cp $fileCopy_fullname /etc/my.cnf
code /etc/my.cnf
brew services restart mysql 

echo "不需要验证密码，直接登录 mysql"
mysql -p   