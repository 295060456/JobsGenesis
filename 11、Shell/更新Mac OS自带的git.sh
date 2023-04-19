
【brew-Git】
# 查看通过 brew 安装的 Git 的安装路径
brew list git
# 打开通过 brew 安装的 Git 的安装路径
open /opt/homebrew/Cellar/git
# 升级 brew 安装的 git
brew upgrade git

# ======================== 

【MaxOS-Git】
# 查看系统当前的 git
git --version 
open /usr/bin/git 


export PATH=/usr/local/bin:$PATH


# 前提是要先安装 MacPorts
open https://www.macports.org/install.php
# MacPorts 环境配置
vim /etc/profile      
# 添加如下
export PATH=/opt/local/bin:$PATH
export PATH=/opt/local/sbin:$PATH

# 升级 MacOS 自带的 Git
sudo port install git

