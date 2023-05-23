#!/bin/bash

# 检测是否已经安装了 brew
if ! command -v brew &> /dev/null
then
    echo "brew 未安装，开始安装..."
    open https://brew.sh/
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ## brew环境变量设置
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
    open /Users/$(whoami)/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "brew 已经安装，跳过安装步骤。"
    ## brew 升级
    brew update
    brew doctor
    brew -v
fi
# 检测是否已经安装了 brew-pandoc
if ! command -v pandoc &> /dev/null
then
    echo "pandoc 未安装，开始安装..."
    brew install pandoc
else
    echo "pandoc 已经安装，跳过安装步骤。"
fi
# 在macOS系统上，用shell脚本实现:键盘监听，输入一个文件路径，提取这个文件的文件名，不带后缀名
## 定义函数，用于提取文件名（不带后缀名）
function get_filename() {
    # 从文件路径中提取文件名（不带后缀名）
    filename=$(basename -- "$1")
    filename="${filename%.*}"
    echo "$filename"
}
## 定义函数，用于提取文件名（不带后缀名）
function get_filename() {
    # 从文件路径中提取文件名（不带后缀名）
    filename=$(basename -- "$1")
    filename="${filename%.*}"
    echo "$filename"
}
# 监听键盘输入
while true; do
    ## 读取用户输入的文件路径
    read -p "请输入文件路径：" filepath
    ## 检查文件是否存在
    if [ ! -f "$filepath" ]; then
        echo "文件不存在，请重新输入。"
        continue
    fi
    ## 检查文件后缀名是否为md
    if [[ "${filepath##*.}" != "md" ]]; then
        echo "文件后缀名不是md，请重新输入。"
        continue
    fi
    ## 提取文件名（不带后缀名）
    filename=$(get_filename "$filepath")
    ## 转换为pdf文件
    pandoc "$filepath" -o "${filename}.pdf"
    ## 输出提示信息
    echo "文件转换完成，生成的pdf文件为：${filename}.pdf"
    ## 退出循环
    break
done