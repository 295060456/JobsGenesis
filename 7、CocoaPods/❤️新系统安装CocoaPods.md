# 新系统安装CocoaPods
## 相关资料来源：
https://blog.csdn.net/u014163312/article/details/124784377
https://juejin.cn/post/6950518188798902286
https://www.jianshu.com/p/c459ecfaf9db
https://www.jianshu.com/p/f3e4ae8e14a6
https://mac.install.guide/ruby/index.html
https://mac.install.guide/faq/do-not-use-mac-system-ruby/index.html
https://www.jianshu.com/p/6ddeade2c565
https://www.shuzhiduo.com/A/qVdeEK1gdP/
https://blog.csdn.net/shentian885/article/details/113548167

## 一些说明
### MacOS Monterey 中的系统 Ruby 是 Ruby 2.6.8(相对较老的版本)。
### 如果您刚开始使用 Ruby，请使用 Homebrew 安装并使用 Ruby 最新版 进行项目。
### 当您开始构建另一个项目时，可能是时候安装一个版本管理器，以便您可以使用不同的 Ruby 版本来处理项目。
### 在您安装了另一个版本的 Ruby 之后，将系统 Ruby 留在原处。不要试图删除它。某些应用程序（或 Apple 的系统软件）可能希望找到它。
### Mac OS 自带 Gem

## 一些准备工作
### 显示Mac OS X上的隐藏文件和文件夹
defaults write com.apple.Finder AppleShowAllFiles YES
### 安装 Xcode Command Line Tools
xcode-select —install
### Mac OS 打开任何来源
sudo spctl --master-disable
### 查看软件更新列表
softwareupdate --list
### 安装所有更新
softwareupdate --install -a
### 查看Command Line Tools的版本
llvm-gcc --version
### 删除rvm
rvm implode

## 开始安装
### 1、查看当前使用的Ruby的安装位置,如果报/usr/bin/ruby,则是系统Ruby环境
which ruby
### 2、使用brew安装一个新的ruby环境，并准备和系统ruby环境进行切换，这里用到RVM
brew install ruby
### 3、检测安装Homebrew:已经安装进行升级保持最新版本;没有安装则下载安装

if brew -v;then
    echo "The package is installed"
    ### brew 升级
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

### 通过brew安装一些软件
brew install ruby
......
brew install llvm
brew install wget
brew install cake
brew install clang-format
brew install docker
brew install git
brew install maven
brew install openjdk
brew install tomcat
brew install yarn

### 4、安装gpg2(可以跳过省略)

brew uninstall gpg gnupg gnupg2
rm -rf /usr/local/etc/gnupg
rm -rf /usr/local/etc/gnupg/scdaemon.conf

brew install gpg gnupg gnupg2 #gpg、gnupg、gnupg2 是一样的
brew link gpg

#### Homebrew 不会自动移除旧版本的软件包,它会帮你释放出来的磁盘空间
brew cleanup

#### 之后想使用gpg2命令还需要创建symlink
ln -s /usr/local/bin/gpg /usr/local/bin/gpg2

### 5、RVM：RVM 是一个命令行工具，可以提供一个便捷的多版本 Ruby 环境的管理和切换。RVM官网 https://rvm.io。安装RVM之前需要安装Homebrew以及gpg2
#### 5.1、自动安装 RVM：\curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles
#### 5.2、手动安装 RVM，解决：[zsh: command not found: RVM]
参考文献：https://blog.csdn.net/shentian885/article/details/113548167
##### 5.2.1、下载RVM
git clone https://github.com/rvm/rvm.git
##### 5.2.2、安装RVM
打开rvm/bin文件夹，双击rvm-installer
##### 5.2.3、启用RVM指令
source ~/.rvm/scripts/rvm

【❤️国内用户需知❤️】
在执行过程中可能会遇到类似curl: (7) Failed to connect to raw.githubusercontent.com port 443: Connection refused的问题；
因为github 的一些域名的 DNS 解析被污染，导致DNS 解析过程无法通过域名取得正确的IP地址；
解决办法就是在本机的hosts文件中添加对应域名解析：
sudo vim /etc/hosts
添加：
199.232.68.133 raw.githubusercontent.com
199.232.68.133 user-images.githubusercontent.com
199.232.68.133 avatars2.githubusercontent.com
199.232.68.133 avatars1.githubusercontent.com
安装完成后修改 RVM 的 Ruby 安装源到 Ruby China 的 Ruby 镜像服务器，这样能提高安装速度
echo "ruby_url=https://cache.ruby-china.com/pub/ruby" > ~/.rvm/user/db
修改~/.bash_profile增加下面的内容：
[[ -s"$HOME/.rvm/scripts/rvm"]] && source"$HOME/.rvm/scripts/rvm"# Load RVM into a shell session *as afunction*

找到ruby-head之前的版本号 rvm list known;例：3.0.0

### 找到ruby-head之前的版本号,例：3.0.0
rvm install 3.0.0
<!--❎-->
<!--Error running '__rvm_make -j8',-->
<!--please read /Users/jobs/.rvm/log/1664825347_ruby-2.7.2/make.log-->
<!--There has been an error while running make. Halting the installation.-->

### 设置 Ruby 版本
rvm use 2.6.6 --default
ruby -v
### 通过手动输入版本号来切换ruby
rvm automount
### ruby的安装位置
gem environment

【❤️国内用户需知❤️】
### 如果人在国内那么就需要更换Gem源
gem sources --remove https://rubygems.org/
gem sources --add https://gems.ruby-china.com/

### 更新安装源缓存
gem sources -u
### 更新Gem本身
sudo gem update --system
sudo gem update --system -n /usr/local/bin
sudo gem install -n /usr/local/bin rubygems-update
### 查看下目前的Gem的版本
gem -v
### 更新所有程序包
gem update
### 使用Gem安装CocoaPods
sudo gem install cocoapods
sudo gem install -n /usr/local/bin cocoapods
sudo gem install cocoapods --pre # 如果你要选择预览版CocoaPods，请使用这一句
### 如果安装了多个Xcode使用下面的命令选择（一般需要选择最近的Xcode版本）
sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer

###安装CocoaPods本地库
git clone https://github.com/CocoaPods/Specs.git ~/.cocoapods/repos/trunk
如果在国内那么就选用清华大学的镜像地址
git clone https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git  ~/.cocoapods/repos/trunk

☕️检查一下安装的成果☕️
pod search Masonry


