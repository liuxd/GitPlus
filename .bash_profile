if [ -f ./.git_aliases ]; then
        . ./.git_aliases
fi

if [ -f ./.git-completion.bash ]; then
    . ./.git-completion.bash
fi

PS1="$PS1\$($( cat ~/git-ps1/git-ps1.sh ))"
