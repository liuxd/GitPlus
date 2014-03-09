#!/bin/bash

#设置git相关内容的彩色显示
git config --global color.status auto
git config --global color.diff auto
git config --global color.branch auto
git config --global color.interactive auto

#别名配置
git config --global alias.st status
git config --global alias.ci commit
git config --global alias.df diff
git config --global alias.co checkout
git config --global alias.br status

#拷贝必要文件
cp .git-completion.bash ~/
cp .git_aliases ~/
cp -r git-ps1 ~/

#配置信息
cat .bash_profile >> ~/.bash_profile
