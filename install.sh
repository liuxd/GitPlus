#!/bin/bash

#colorful
git config --global color.status auto
git config --global color.diff auto
git config --global color.branch auto
git config --global color.interactive auto

#aliases
git config --global alias.st status
git config --global alias.ci commit
git config --global alias.df diff
git config --global alias.co checkout
git config --global alias.br status

#copy
cp .git-completion.bash ~/
cp .git_aliases ~/
cp -r git-ps1 ~/

#configure
cat .bash_profile >> ~/.bash_profile
