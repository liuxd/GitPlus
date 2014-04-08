#!/bin/bash

#copy
cp .git-completion.bash ~/
cp .git_aliases ~/
cp .gitconfig ~/
cp .gitignore ~/
cp -r git-ps1 ~/

#configure
cat .bash_profile >> ~/.bash_profile
cat .bashrc >> ~/.bashrc
