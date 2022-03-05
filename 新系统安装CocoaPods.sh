#! /bin/sh

# 如果没有执行权限，在这个sh文件的目录下，执行chmod u+x *.sh

# Mac安装Ruby版本管理器（RVM）
# 资料来源
## https://www.jianshu.com/p/e36c0a1c6b49

# brew->ruby->Gem->CocoaPods

echo "============== 一些准备工作 ==============="
echo "显示Mac OS X上的隐藏文件和文件夹"
defaults write com.apple.Finder AppleShowAllFiles YES
echo "安装Xcode Command Line Tools"
xcode-select —install
echo "Mac OS 打开任何来源"
sudo spctl --master-disable
echo "正在安装Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install wget
brew install cake
echo "============== 前言（序）==============="
echo "RVM是一个命令行工具，它允许您轻松地安装，管理和使用从解释器到多组宝石的多个ruby环境。"
echo "使用Ruby原因：
1、虽然 macOS 自带了一个 ruby 环境，但是是系统自己使用的，所以权限很小，只有 system。
2、而/Library 目录是 root 权限,所以很多会提示无权限。
3、使用自带ruby更新,管理不方便
4、一系列无原因的报错"
echo "============== 废话完 =============="
echo "如果您使用的是Ruby系统，OS X将回应： /usr/bin/ruby"
which ruby
echo "检查使用哪个版本的Ruby OS X"
ruby -v
echo "============== ❤️开始安装RVM❤️ =============="
echo "开始安装mpapis公钥。但是，正如安装页面所记录的，您可能需要gpg。Mac OS X不附带gpg，因此在安装公钥之前，需要安装gpg。这里用Homebrew安装了gpg"
brew install gnupg
echo "安装完gpg之后、正在安装mpapis公钥..."

# 解决 gpg: command not found
brew uninstall gpg gnupg gnupg2
brew reinstall gpg gnupg gnupg2
brew link gnupg

gpg --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
echo "安装最新版本的Ruby的RVM"
\curl -sSL https://get.rvm.io | bash -s stable --ruby
echo "切换rvm"
source /Users/sino/.rvm/scripts/rvm
echo "检查使用的是否是系统自带的Ruby还是我们自定义的Ruby环境"
which ruby
echo "============== Gem ==============="
echo "ruby 是一种语言，是某些软件包代码的执行环境。而Gem是管理这些基于ruby程序的程序。"
echo "Mac OS 自带Gem"
echo "列出安装源"
gem sources -l
# 如果人在国内那么就需要更换Gem源
gem sources --remove https://rubygems.org/
gem sources --add https://gems.ruby-china.com/
echo "更新安装源缓存"
gem sources -u
echo "更新Gem本身"
gem update --system
echo "查看下目前的Gem的版本"
gem -v
echo "更新所有程序包"
gem update
echo "============== 使用Gem安装CocoaPods =============="
sudo gem install -n /usr/local/bin cocoapods
#sudo gem install cocoapods --pre # 如果你要选择预览版CocoaPods，请使用这一句
echo "如果安装了多个Xcode使用下面的命令选择（一般需要选择最近的Xcode版本）"
sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
echo "============== 安装CocoaPods本地库 ==============="
git clone https://github.com/CocoaPods/Specs.git ~/.cocoapods/repos/trunk
# 如果在国内那么就选用清华大学的镜像地址
#git clone https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git  ~/.cocoapods/repos/trunk
echo "☕️检查一下安装的成果☕️"
pod search Masonry


