#!/bin/zsh

export PATH="$PATH:$HOME/.composer/vendor/bin"

#autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

#Alias
alias bup="brew update; brew cleanup; brew cask cleanup"
alias dbc="rm -v /Users/zhangzhong/Library/Application\ Support/Beyond\ Compare/registry.dat"
alias chds="open -a Google\ Chrome --args --disable-web-security --user-data-dir=/Users/zhangzhong/Library/Application\ Support/Google/Chrome/personal"
alias phptag="ctags --languages=php --extra=* --fields=* --recurse ."
alias npm="npm --registry=https://registry.npm.taobao.org --cache=$HOME/.npm/.cache/cnpm --disturl=https://npm.taobao.org/dist"
alias sshtq="ssh root@114.215.159.150 -p 20002"
alias sshaq="ssh root@115.28.134.113 -p 20002"
