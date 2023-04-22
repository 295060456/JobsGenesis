# MacOS环境变量

[toc]

```javascript
资料来源
https://www.jianshu.com/p/acb1f062a925
```

## 1、系统变量的加载顺序

### 1.1、🇨🇳【系统级别】

```
/etc/profile 
```

```
✅全局建议修改这个文件
/etc/paths 
```

### 1.2、👤【当前用户】

从上到下，若文件存在，则不再往下读取。以此类推

```
~/.bash_profile

 🈲 建议不修改这个文件，全局（公有）配置，不管是哪个用户，登录时都会读取该文件。该文件包含专用于你的bash shell的bash信息（每个用户都有一个.bashrc文件，在用户目录下）

注：因为安装zsh，~/.bash_profile就不会被执行。解决办法有以下两种：
1、vim ~/.zshrc 将你要配置到环境变量配置到该文件中即可
2、vim ~/.zshrc 将 source ~/.bash_profile 添加到末尾，这样~/.bash_profile配置的环境变量同样有效
3、使得配置文件生效 source ~/.zshrc
```

```
~/.bash_login

注：对于 MacOS，有可能不存在此文件目录
```

```
~/.profile

 ✅该文件为系统的每个用户设置环境信息,当用户第一次登录时,该文件被执行.并从/etc/profile.d目录的配置文件中搜集shell的设置

注：如果你有对/etc/profile有修改的话必须得重启你的修改才会生效，此修改对每个用户都生效【全局性】
注：对于 MacOS,目录/etc/profile.d 有可能不存在
```

```
~/.bashrc 

没有上述规则，它是bash shell打开的时候载入的。不管是何种方式，都会读取此文件。✅一般在这个文件中添加系统级环境变量

注：对所有的使用bash的用户修改某个配置并在以后打开的bash都生效的话可以修改这个文件，修改这个文件不用重启，重新打开一个bash即可生效
```

## 2、编辑系统变量

### 2.1、编辑环境变量（亦可以使用vi）

```bash
vim /etc/profile
vim /etc/paths
vim ./.bash_profile
vim ./.bash_login(对于 MacOS，有可能不存在此文件目录)
vim ./.profile
vim ./.bashrc
```

### 2.2、环境信息生效：source

```bash
source /etc/profile
source /etc/paths
source ./.bash_profile
source ./.bash_login
source ./.profile
source ./.bashrc
```

### 2.3、语法

```bash
PATH的语法：中间用冒号隔开
export PATH=$PATH:<PATH 1>:<PATH 2>:<PATH 3>:------:<PATH N>
```

## 3、关于打印输出

### 3.1、竖排打印环境变量，并输出到本目录下面的 localGoEnvInfo.md文件（易读）

```bash
sed 's/:/\n/g' <<< "$PATH" >> localGoEnvInfo.md
```

### 3.2、直接输出（不易读）

```bash
echo $PATH
```

### 3.3、去除环境变量中的重复项

注意sed的用法，linux和MacOS不同，linux是Gnu的，MacOS是BSD的

```bash
export PATH=$$PATH | tr ':' '\n' | sort | uniq | tr -s '\n' ':' | sed 's/:$//g')
export PATH=$(echo $PATH | sed 's/:/\'$'\n/g' | sort | uniq | tr -s '\n' ':' | sed 's/:$//g')
```

# 第三方的 Bash

## 1、Oh-My-Zsh

### 1.1、官方网站

```javascript
https://ohmyz.sh/
https://ohmyposh.dev/
```

### 1.2、安装

#### 1.2.1、直接安装到本系统

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
或者
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```

#### 1.2.2、通过 brew 安装

```
brew install Oh-My-Zsh
brew install oh-my-posh
```

### 1.3、兼容系统配置（新建生成.sh脚本文件）

#### 1.3.1、【方式一】手动添加到文件末尾

`source ~/.bash_profile`

#### 1.3.2、【方式二】通过运行脚本文件写入

```bash
#!/bin/bash

grep source ~/.bash_profile
# 防止有些没有安装zsh
if [ $? -eq 1 ] ;then
  echo 'source ~/.bash_profile' >> ~/.zshrc
  source ~/.zshrc
fi
```

### 1.4、卸载

#### 1.4.1、【卸载】直接安装到本系统

```
uninstall_oh_my_zsh
```

#### 1.4.2、【卸载】通过 brew 安装

```
brew uninstall Oh-My-Zsh
brew uninstall oh-my-posh
```

