
# 资料来源
# https://www.jianshu.com/p/acb1f062a925

# 理论篇
# Mac系统的环境变量，加载顺序为：

# 🇨🇳【系统级别】
# /etc/profile 
# /etc/paths ✅全局建议修改这个文件

# 👤【当前用户】从上到下，若文件存在，则不再往下读取。以此类推
# ~/.bash_profile 🈲建议不修改这个文件，全局（公有）配置，不管是哪个用户，登录时都会读取该文件。该文件包含专用于你的bash shell的bash信息（每个用户都有一个.bashrc文件，在用户目录下）
# ~/.bash_login ❓
# ~/.profile ✅该文件为系统的每个用户设置环境信息,当用户第一次登录时,该文件被执行.并从/etc/profile.d目录的配置文件中搜集shell的设置
# 使用注意：如果你有对/etc/profile有修改的话必须得重启你的修改才会生效，此修改对每个用户都生效
# ~/.bashrc 没有上述规则，它是bash shell打开的时候载入的。不管是何种方式，都会读取此文件。✅一般在这个文件中添加系统级环境变量
# 使用注意 对所有的使用bash的用户修改某个配置并在以后打开的bash都生效的话可以修改这个文件，修改这个文件不用重启，重新打开一个bash即可生效

# 编辑环境变量（亦可以使用open）
# vim /etc/profile
# vim /etc/paths
# vim ./.bash_profile
# vim ./.bash_login
# vim ./.profile
# vim ./.bashrc

# 环境信息生效：
# source /etc/profile
# source /etc/paths
# source ./.bash_profile
# source ./.bash_login
# source ./.profile
# source ./.bashrc

# PATH的语法
# 中间用冒号隔开    export PATH=$PATH:<PATH 1>:<PATH 2>:<PATH 3>:------:<PATH N>

echo $PATH

open ~/.zshrc
