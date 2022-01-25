#! /bin/sh

#if[ "$(uname)"=="Darwin" ];then
#echo $"Mac OS X 操作系统"
#elif[ "$(expr substr $(uname -s) 1 5)"=="Linux" ];then
#echo $"GNU/Linux操作系统"
#elif[ "$(expr substr $(uname -s) 1 10)"=="MINGW32_NT" ];then
#echo $"Windows NT操作系统"
#fi

# Mac 一般使用bash作为默认shell
# Mac系统的环境变量，加载顺序为：
# 1、/etc/profile【系统级别,系统启动就会加载】（建议不修改这个文件:全局（公有）配置，不管是哪个用户，登录时都会读取该文件。）
# 2、/etc/paths【系统级别,系统启动就会加载】（全局建议修改这个文件）
#    # 后面几个是当前用户级的环境变量。后面3个按照从前往后的顺序读取，
#    # 如果~/.bash_profile文件存在，则后面的几个文件就会被忽略不读了，
#    # 如果~/.bash_profile文件不存在，才会以此类推读取后面的文件。
# 3、~/.bash_profile 任意一个文件中添加用户级环境变量;注：Linux 里面是 .bashrc 而 Mac 是 .bash_profile
# 4、~/.bash_login
# 5、~/.profile
#    #~/.bashrc没有上述规则，它是bash shell打开的时候载入的
# 6、~/.bashrc
# /etc/bashrc （一般在这个文件中添加系统级环境变量）全局（公有）配置，bash shell执行时，不管是何种方式，都会读取此文件

echo $"在MacOS X 10.5或更高版本上,返回默认JDK的位置👇🏻"
/usr/libexec/java_home
echo $"查找所有已安装的jdk👇🏻"
/usr/libexec/java_home -V

# ❤️获取当前的相对路径❤️
basedir=`cd $(dirname $0); pwd -P`
echo "当前项目的绝对路径为: $basedir"
fileName=$"被读取的临时文件"
fileExtension="txt"
filePath=$basedir$"/"$fileName$"."$fileExtension
checkString=$"JavaHome"
# -w 就是完全匹配，否则就是模糊匹配（包含）
order=$"grep -c -w "$" "$checkString$" "$filePath
# 要取函数的返回值需要用``;字符串转为可执行的函数关键字：eval
result=`eval $order`
echo $result

if [ $result -eq 0 ];then
    echo "不存在"
elif [ $result -eq 1 ];then
    echo "有且存在一个"
else
    echo "存在多个"
fi

echo $"==============="

echo $"打开Java官网下载页面"
open -a "/Applications/Safari.app" https://www.java.com/en/download/manual.jsp
# ❤️Java虚拟机下载地址❤️
#JavaEnvDownLoadURL="https://javadl.oracle.com/webapps/download/AutoDL?BundleId=245798_df5ad55fdd604472a86a45a217032c7d"
JavaEnvDownLoadURL="https://github.com/JobsKit/JobsCodeSnippets/archive/refs/heads/main.zip"
echo "下载地址为 : "$JavaEnvDownLoadURL
# 关于Shell获取系统时间的几点说明：
## 1、date后面有一个空格，否则无法识别命令，shell对空格还是很严格的;
## 2、Y显示4位年份;
## 3、"+%Y-%m-%d %H:%M:%S",前面的➕是必写，否则语法报错;
### 如：2018；y显示2位年份，
### 如：18。m表示月份；
#### M表示分钟。
#### d表示天，而D则表示当前日期，
### 如：1/18/18(也就是2018.1.18)。
### H表示小时，而h显示月份(有点懵逼)。
### s显示当前秒钟，单位为毫秒；S显示当前秒钟，单位为秒。
time=$(date "+%Y-%m-%d %H:%M:%S")
echo $"当前下载的时间为："${time}
echo "[`date` ]"
DownloadFileName=`date`
# 去除文件名里面的空格,否则保存文件名会异常
DownloadFileName=${DownloadFileName// /-}
echo DownloadFileName = $DownloadFileName
# 统一用zip格式
DownloadFileNameSuffix="zip"
# 下载到路径👇🏻
echo ======
# 用wget可以保持服务器远端的文件名
# 用curl需要自定义接受的文件名和后缀名
wgetDownloadFilePath=$basedir"/"
curlDownloadFilePath=$wgetDownloadFilePath$DownloadFileName"."$DownloadFileNameSuffix
echo curlDownloadFilePath = $curlDownloadFilePath
echo ======
function wgetDownloadJavaEnv(){
#echo $"下载JDK(不同版本JDK更换链接即可)"
## wget命令下载方式(不用重定向)
### wget命令参数解释👇🏻
#### –no-check-certificate：表示不校验SSL证书，因为中间的两个302会访问https，会涉及到证书的问题，不校验能快一点，影响不大。
#### –no-cookies：表示不使用cookies,当然首次在header里指定的会带上，后面重定向的就不带了，这个影响也不大，可以不加。
wgetDownloadJavaEnv=$"wget --no-check-certificate --no-cookies --header"$" "$"Cookie: oraclelicense=accept-securebackup-cookie"$" -P "$wgetDownloadFilePath$" "$JavaEnvDownLoadURL
eval $wgetDownloadJavaEnv
}

function curlDownloadJavaEnv(){
### curl命令下载方式
#### curl命令参数解释👇🏻
##### -L：-L参数能够追踪重定向的地址，不加-L只能返回302的结果（因为安装过程中会发生三次重定向）
##### -H：cookies中有用的内容是同意协议那一部分，Connection: keep-alive这句要加上，否则下载速度会变成蜗牛
##### -O：curl要通过-O参数才能下载文件，否则只是将内容输出到控制台
curlDownloadJavaEnv=$"curl"$" -L "$JavaEnvDownLoadURL$" -H "$"Cookie: oraclelicense=accept-securebackup-cookie"$" -H "$"Connection: keep-alive"$" -o "$curlDownloadFilePath
eval $curlDownloadJavaEnv
}

function choseDownloadJavaEnvStyle(){
    read name # 把键盘输入放入变量name
    if [ $name -eq 1 ];then
        echo $"你选择的是wget方式下载"
        wgetDownloadJavaEnv
        return $name
    elif [ $name -eq 2 ];then
        echo $"你选择的是curl方式下载"
        curlDownloadJavaEnv
        return $name
    else
        echo $"请重新输入"
        return 0
    fi
}
res2=0
while [ $res2 -eq 0 ];do
    # 参数-n的作用是不换行，echo默认换行
    echo "选择下载方式，键入1用wget，键入2用curl"
    # ❤️重要内容❤️
    # 必须要一个变量来进行承接，也就是说必须写res1=，才能正确输出retuen的内容
    res1=$(choseDownloadJavaEnvStyle)
    #res1=`eval choseDownloadJavaEnvStyle`
    res2=`echo $?`
    echo $res1
    # 👇🏻这种打印方式只能输出echo
    # res3=$(choseDownloadJavaEnvStyle)
    # echo $"res3 = "$res3
done

# 下载完成打开根文件夹📂
open ~

