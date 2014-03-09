#!/bin/bash
#
# git-ps1 - git-augmented PS1
#
# See README for configuration options.
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
# #

branch=$(git symbolic-ref HEAD 2>/dev/null \
    || git rev-parse HEAD 2>/dev/null | cut -c1-10 \
)

# if no branch or hash was returned, then we're not in a repository
if [ -z "$branch" ]; then
    exit
fi

# creates a color from the given color code
mkcolor()
{
    echo "\[\033[00;$1m\]"
}

branch=${branch#refs/heads/}
git_status=$( git status 2>/dev/null )
if [ "$?" != '0' ]; then
    exit
fi

# colors can be overridden via the GITPS1_COLOR_* environment variables
color_default=$( mkcolor ${GITPS1_COLOR_DEFAULT:-33} )
color_fastfwd=$( mkcolor ${GITPS1_COLOR_FASTFWD:-31} )
color_staged=$( mkcolor ${GITPS1_COLOR_STAGED:-32} )
color_untracked=$( mkcolor ${GITPS1_COLOR_UNTRACKED:-31} )
color_unstaged=$( mkcolor ${GITPS1_COLOR_UNSTAGED:-33} )
color_ahead=$( mkcolor ${GITPS1_COLOR_AHEAD:-33} )
color_state=$( mkcolor ${GITPS1_COLOR_STATE:-35} )
color_clr=$( mkcolor 0 )

# indicators may be overridden via the GITPS1_IND_* environment vars; set to
# '0' to disable
ind_staged=${GITPS1_IND_STAGED:-*}
ind_unstaged=${GITPS1_IND_UNSTAGED:-*}
ind_untracked=${GITPS1_IND_UNTRACKED:-*}
ind_ahead=${GITPS1_IND_AHEAD:-@}
ind_ahead_count=${GITPS1_IND_AHEAD_COUNT:-@}
ind_state=${GITPS1_IND_STATE:-1}

statusmsg=''
statemsg=''
color=$color_default

# uncommited files
if [ "$ind_unstaged" != '0' ]; then
    git diff --no-ext-diff --quiet --exit-code 2>/dev/null || \
        statusmsg="${statusmsg}${color_unstaged}${ind_unstaged}"
fi

# not on branch/behind origin
if [ "$( echo $git_status | grep 'Not currently on\|is behind' )" ]; then
    color=$color_fastfwd
fi

# staged
if [  "$ind_staged" != '0' ]; then
    if [ "$( echo $git_status | grep 'to be committed' )" ]; then
        statusmsg="${statusmsg}${color_staged}${ind_staged}"
    fi
fi

# untracked
if [ "$ind_untracked" != '0' ]; then
    if [ -n "$( git ls-files --others --exclude-standard 2>/dev/null )" ]; then
        statusmsg="${statusmsg}${color_untracked}${ind_untracked}"
    fi
fi

# ahead of tracking
if [ "$ind_ahead" != '0' ]; then
    grep -q 'is ahead' <<< "$git_status" && {
        statusmsg="${statusmsg}${color_ahead}${ind_ahead}"

        # append count?
        if [ "$ind_ahead_count" != '0' ]; then
            ahead_count=$( echo $git_status \
                | grep -o 'by [0-9]\+ commits\?' \
                | cut -d' ' -f2 \
            )
            statusmsg="${statusmsg}${ahead_count}"
        fi
    }
fi

# state message
if [ "$ind_state" != '0' ]; then
    statemsg=$( git state 2>/dev/null ) && state=" $color_state($statemsg)"
fi

# output the status string
echo "$color[${branch}${statusmsg}${color}]$state$color_clr "
