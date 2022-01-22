#! /bin/sh

echo "卸载Cocoapods"
sudo gem uninstall cocoapods
echo "查看本地安装过的cocopods相关东西"
gem list --local | grep cocoapods
# 然后使用命令逐个删除

