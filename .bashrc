#!/bin/bash
# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set editor
export VISUAL=nvim
export EDITOR=nvim

# working with dotfiles version control
alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias d='dots'

# faster text editing potential
alias vi='nvim'
alias g='git'

# nice colorizing
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# vimy bash exiting
alias :q='exit'
alias :wq='exit'

# tar help
alias tar-unzip='tar -xvzf'

# update pacman mirrors
# NOTE: this command assumes you changed your mirror list to a file called
# `newmirrorlist` in `/etc/pacman.d/`. This is nice because it keeps the
# original mirror list as a backup.
alias pacman-update-mirrors='sudo reflector --verbose -c "United States" --latest 5 --age 12 --protocol http,https --sort rate --save /etc/pacman.d/newmirrorlist'

# quicker updates
alias update='sudo pacman -Syu'

# navigation
alias ..='cd ..'

# simple way to count lines of code in the current directory
loc() {
    if [[ -z "$1" ]]; then
        command find . -regextype sed -not -regex '\./\.git.*' -type f | xargs wc -l | sort -n
    else
        command find . -regextype sed -not -regex '\./\.git.*' -regex ".*\.$1" -type f | xargs wc -l | sort -n
    fi
}

# get wezterm undercurl after following these steps:
# https://wezfurlong.org/wezterm/faq.html?highlight=undercur#how-do-i-enable-undercurl-curly-underlines
if [[ $TERM_PROGRAM == "WezTerm" ]]; then
    export TERM="wezterm"
fi

# Cool `PS1` prompt
# NOTE: on Konsole or Kitty with transparent background the parts of the prompts
# that share the same color as the background color (if any, determined by color
# scheme) will also be transparent. Workaround is only to disable transparency
# or change that base color of the scheme (usually 0) to, say, 1 value off of
# the original. Hacky but works.

PROMPT_COMMAND=_prompt_command
_prompt_command() {
    if [ $? -eq 0 ]; then
        local color='2'
    else
        local color='1'
    fi
    PS1="\e[3${color}m╭\e[40m┨\e[37m\e[40m  \e[1m\u \e[0m\e[30m\e[4${color}m \e[3m\e[1m\e[30m\w \e[0m\e[00m\e[3${color}m\n\e[3${color}m╰─🢒\e[00m\$ \e[00m"
}

# various environment variables for program configuration
export BAT_THEME="bamboo"
export RIPGREP_CONFIG_PATH="$HOME/.config/rg/.ripgreprc"

[ -f "/home/rileyb/.ghcup/env" ] && source "/home/rileyb/.ghcup/env" # ghcup-env

# access Node.js dependencies from Bash prompt when in project root
export PATH=$PATH:./node_modules/.bin

# start shell with fastfetch
fastfetch
