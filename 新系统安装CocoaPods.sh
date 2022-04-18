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
#brew install clang-format
#brew install docker
#brew install git
#brew install maven
#brew install openjdk
#brew install tomcat
#brew install yarn
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
echo "正在删除 /usr/local/etc/gnupg"
rm -rf /usr/local/etc/gnupg
echo "正在删除 /usr/local/etc/gnupg/scdaemon.conf"
rm -rf /usr/local/etc/gnupg/scdaemon.conf
brew reinstall gpg #gpg、gnupg、gnupg2 是一样的
brew link gpg

# Homebrew 不会自动移除旧版本的软件包,它会帮你释放出来的磁盘空间
brew cleanup

echo "===== RVM的前导工作开始 ====="
echo "详情请参阅：https://rvm.io/rvm/security"
open -a "/Applications/Safari.app" https://rvm.io/rvm/security
echo "在 RVM，我们非常重视安全性，并对1.26.0所有版本和rvm-installer脚本进行加密签名（自版本以来），以确保其来自真实来源。"
echo "我们使用 GPG 进行签名。两者都gpg应该gpg2没问题。"
echo "有时gpg从远程服务器下载密钥时会出现问题，gpg2如果它可用于您的系统，则使用它可能会更好。然而据报道，gpg2在 2.1.17 版本中也受到此类问题的影响。我们建议您将其降级或升级到较新的版本。"
echo "409B6B1796C275462A1703113804BB82D39DC0E3 # mpapis"
echo "7D2BAF1CF37B13E2069D6956105BD0E739499BDB # pkuczynski"
echo "作为第一步，在尝试安装 RVM 之前，您应该安装gpg2并导入以上👆🏻这些密钥："

echo "如果密钥服务器遇到问题，有下列👇🏻服务器进行替换方案"
echo "hkp://ipv4.pool.sks-keyservers.net(官网推荐)"
echo "hkp://pgp.mit.edu(官网推荐)"
echo "hkp://keyserver.pgp.com(官网推荐)"
echo "hkp://pool.sks-keyservers.net(官网推荐)"
echo "hkp://keys.gnupg.net"

gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

gpg --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

gpg --keyserver hkp://keyserver.pgp.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

echo "防火墙问题"
echo "如果导入 gpg 密钥永远挂起，那可能是防火墙问题。如果您位于防火墙后面，请确保打开传出端口 11371 (TCP)。"
echo "IPv6 问题"
echo "已知问题是，如果您的主机未启用 IPv6（通常发生在 docker 容器中），某些关键服务器可能无法连接。您可以通过将以下行添加到以下行来禁止 gpg 的内部dirmngr使用 IPv6 ~/.gnupg/dirmngr.conf：禁用 IPv6"
echo "确保没有现有dirmngr进程仍在运行（如果有，则将其杀死），然后gpg --recv-keys按照最初指定的方式再次尝试命令，它应该可以工作。
请注意，这里的风险是，如果您稍后确实需要 IPv6，您可能会忘记此设置，但对于大多数人来说，这不太可能。"

echo "运行验证安装"
\curl -sSL https://get.rvm.io | bash -s stable

echo "定期刷新Key"
echo "定期刷新密钥状态以确保它们都没有被撤销是一种很好的做法。您也可以将其添加到 cron。"
gpg --refresh-keys

echo "===== RVM的前导工作结束 ====="

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


