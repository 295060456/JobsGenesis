#! /bin/sh
#
#if [[ $key = "" ]]; then
#
#echo 'You pressed enter!'
#
#else
#
#echo "You pressed '$key'"
#
#fi

echo -n "Enter your name:"                   # 参数-n的作用是不换行，echo默认换行
read name                                   # 把键盘输入放入变量name
echo "hello $name,welcome to my program"     # 显示输入信息
exit 0

