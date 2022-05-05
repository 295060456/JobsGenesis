#! /bin/sh

# 如果没有执行权限，在这个sh文件的目录下，执行chmod u+x *.sh

echo "======== 不管系统有没有安装brew 首先全部归零 ========"
echo "执行brew垃圾清除..."
brew cleanup
echo "准备卸载Homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"  
echo "准备手动清除Homebrew安装残留（可能需要输入管理员密码）"
sudo rm -rf /usr/local/Caskroom/
sudo rm -rf /usr/local/Frameworks/
sudo rm -rf /usr/local/Homebrew/
sudo rm -rf /usr/local/bin/
sudo rm -rf /usr/local/etc/
sudo rm -rf /usr/local/include/
sudo rm -rf /usr/local/lib/
sudo rm -rf /usr/local/opt/
sudo rm -rf /usr/local/sbin/
sudo rm -rf /usr/local/share/
sudo rm -rf /usr/local/var/
# 解决 Running `brew update --preinstall`... fatal: Could not resolve HEAD to a revision
sudo rm -rf $(brew --repo homebrew/core)
echo "======== 执行完毕brew归零操作 ========"

echo "正在安装Homebrew..."
#Error: Can't create update lock in /usr/local/var/homebrew/locks! Fix permissions by running:
sudo chown -R $(whoami) /usr/local/var/homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "环境变量设置..."
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)" 

echo "安装一些插件"
brew install --cask cakebrew
brew install --cask launchrocket

brew install docker
brew install carthage
brew install php
brew install mysql
brew install tomcat
brew install maven
brew install java
brew install -g node
brew install nvm
brew install docker
brew install python3
brew install openssl
brew install wget
brew install heroku
brew install git
brew install autojump
brew install Mongodb
brew install Nginx
brew install iTerm2
brew install xz
brew install pkg-config
brew install readline
brew install coreutils
brew install lrzsz
brew install clang-format
brew install git-flow
brew install Autojump
brew install caskroom/cask/brew-cask
brew install tomcat
brew install ruby
brew install ffmpeg
brew install watchman
brew install gnupg
brew install oclint
brew install yarn # 或者 brew reinstall yarn --without-node 如果您使用 nvm 或类似的东西，您应该排除安装 Node.js 以便使用 nvm 的 Node.js 版本
brew install cask

# brew upgrade
# brew reinstall




