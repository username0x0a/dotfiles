# ~/.bashrc: executed by bash(1) for non-login shells.
# See /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Don't put duplicate lines in the history. See bash(1) for more options
# Don't overwrite GNU Midnight Commander's setting of `ignorespace'.
#HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL="ignoreboth" # same as "ignorespace:ignoredups"
export HISTIGNORE="ls:history:[bf]g:exit:quit"
# ... plus some of the aliases defined below
export HISTIGNORE="$HISTIGNORE:ll:la:\.\.*:^q[q]*$"
# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1024
export HISTFILESIZE=4096

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# More shopts
#shopt -s autocd             # change to named directory
shopt -s cdable_vars        # if cd arg is not valid, assumes its a var defining a dir
shopt -s cdspell            # autocorrects cd misspellings
shopt -s cmdhist            # save multi-line commands in history as single line
shopt -s dotglob            # include dotfiles in pathname expansion
shopt -s expand_aliases     # expand aliases
shopt -s extglob            # enable extended pattern-matching features
shopt -s hostcomplete       # attempt hostname expansion when @ is at the beginning of a word
shopt -s nocaseglob         # pathname expansion will be treated as case-insensitive

# Bash completion
set show-all-if-ambiguous on

# Visual bell
set bell-style visible

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# Uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

set_prompt_style () {
	if [ "$color_prompt" = yes ]; then
		local BLUE="\[\033[0;34m\]"
		local DARK_BLUE="\[\033[1;34m\]"
		local RED="\[\033[0;31m\]"
		local DARK_RED="\[\033[1;31m\]"
		local DARK_GREEN="\[\033[0;32m\]"
		local GREEN="\[\033[1;32m\]"
		local NO_COLOR="\[\033[0m\]"
		case $TERM in
			xterm*|rxvt*)
				TITLEBAR='\[\033]0;\u@\h:\w\007\]'
				;;
			*)
				TITLEBAR=""
				;;
		esac
		local MACHINE_COLOR="$DARK_RED"
		PS1="$MACHINE_COLOR\h$NO_COLOR:$GREEN\W$NO_COLOR \u$DARK_RED\$$NO_COLOR "
		PS2='continue-> '
		PS4='$0.$LINENO+ '
	else
		PS1='${debian_chroot:+($debian_chroot) }\h:\W \u\$ '
	fi
}
set_prompt_style
unset color_prompt force_color_prompt

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Misc functions
manread () {
	nroff -man $1 | more
}

sweep () {
	unset HISTFILE;
}

quit () {
	exit;
}

sweep_quit () {
	sweep; exit;
}

screen_recover () {
	screen -r $(screen -ls | grep pts | head -1 | sed "s/^\([ \t]*\)\([0-9]*\).*/\\2/")
}

mkvmdk () {
	[ -z $1 ] && echo "Usage: $0 <device> <file>" && return
	[ -z $2 ] && echo "Usage: $0 <device> <file>" && return
	VBoxManage internalcommands createrawvmdk -filename $2 -rawdisk $1
}

mkramfs () {
	[ -z $1 ] && echo "Usage: $0 <size in MB>" && return
	[ $1 -lt 0 ] && echo "$0: Size must be specified properly" && return
	local SIZE=$(($1 * 2048))
	diskutil erasevolume HFS+ "ramdisk" `hdiutil attach -nomount ram://$SIZE`
}

notify () {
	if [ $# -eq 0 ]; then
		osascript -e 'display notification with title "Notification!"';
	elif [ $# -eq 1 ]; then
		osascript -e "display notification \"$1\" with title \"Notification!\"";
	else
		osascript -e "display notification \"$2\" with title \"$1!\"";
	fi
}

git-clean () {
	git clean -f -d
}

git-collect-garbage () {
	git reflog expire --expire=now --all
	git gc --prune=now
	git push --all --force
	git push --tags --force
}

# Set defaults
export EDITOR="nano"
export FCEDIT="vim"
export BROWSER=/usr/bin/links

# Some more ls aliases
alias l="ls -l"             # show directory list
alias ll="ls -al"           # show directory list, including hidden files
alias la="ls -a"            # show hidden files
alias lx="ls -xb"           # sort by extension
alias lk="ls -lSr"          # sort by size, biggest last
alias lc="ls -ltcr"         # sort by and show change time, most recent last
alias lu="ls -ltur"         # sort by and show access time, most recent last
alias lt="ls -ltr"          # sort by date, most recent last
alias lm="ls -al |more"     # pipe through 'more'
alias lr="ls -lR"           # recursive ls
alias lsr="tree -Csu"       # nice alternative to 'recursive ls'
alias lh='ls -ld .*'
alias xdu='du -hs *'
alias xdh='du -hs .[^.]*'

# The 'cd' family
alias h="cd ~"
alias home="cd ~"
alias ..="cd .."           # go back one directory
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Other
alias thetime="date +%H:%M:%S"
alias q="quit"
alias qq="sweep_quit"
alias free="free -m"
alias resume="screen_recover"
alias nossh="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
alias jsc="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc"
alias diffy="diff -Naur"
alias itms="/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/itms/bin/iTMSTransporter"
alias midnight="ruby -e 'puts Time.now.to_i/86400*86400'"
alias ruby-server="ruby -run -e httpd . -p 8000"
alias python-server="python -m SimpleHTTPServer 8000"
alias dequarantine="xattr -d com.apple.quarantine"
alias resign-xcode="sudo codesign -f -s XcodeSigner --deep --no-strict"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

umask 0002

PATH=$PATH:~/bin # Add ~/bin directory to path
