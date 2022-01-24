#! /bin/sh

# 如果没有执行权限，在这个sh文件的目录下，执行chmod u+x *.sh

brew update
brew install ruby
echo 'export PATH="/usr/local/opt/ruby/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
