#!/bin/bash
# https://www.jianshu.com/p/a977c0a03bf4

# 如果没有执行权限，在这个sh文件的目录下，执行chmod u+x *.sh

echo "这个是第一次在工程里面使用pods的时候使用，并且，也是每次你编辑你的Podfile（添加、移除、更新）的时候使用。"
echo "每次运行pod install命令的时候，在下载、安装新的库的同时，也会把你安装的每个库的版本都写在了Podfile.lock文件里面。这个文件记录你每个安装库的版本号，并且锁定了这些版本。"
echo "当你使用pod install它只解决了pods里面，但不在Podfile.lock文件里面的那些库之间的依赖。"
echo "对于在Podfile.lock里面所列出的那些库，会下载在Podfile.lock里面明确的版本，并不会去检查是否该库有新的版本。"
echo "对于还不在Podfile.lock里面的库，会找到Podfile里面描述对应版本（例如：pod "MyPod", "~>1.2"）。"
pod install
echo "当你运行 pod update PODNAME 命令时，CocoaPods会帮你更新到这个库的新版本，而不需要考虑Podfile.lock里面的限制，它会更新到这个库尽可能的新版本，只要符合Podfile里面的版本限制。"
echo "如果你运行pod update，后面没有跟库的名字，CocoaPods就会更新每一个Podfile里面的库到尽可能的最新版本。"
#pod update
