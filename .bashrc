# Nice colors for less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt

force_colored_prompt=yes

# some more ls aliases
alias l='ls -lhFG'
alias di='sudo dpkg -i'
alias dl='sudo dpkg -l'
alias dc='sudo dpkg -c'
alias dp='sudo dpkg -P'
alias gits='git status'
alias gitl='git log'
alias gitp='git pull'
alias gitpr='git pull --rebase'
alias gitd='git diff --ext-diff'
alias gitc='git commit'
alias gitco='git checkout'
alias gitcur='git log | head -n 1|cut -d " " -f 2'
alias gitclean='git clean -x -d -f'
alias gitb='git branch -a'
alias gitss='git stash save'
alias gitsa='git stash apply'
alias ..='cd ..'

function parse_git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    status=`git ls-files -m|wc -l|tr -d ' '`
    if [ ${status:-0} -gt 0 ]; then
        echo -e "("${ref#refs/heads/}") <${status}> "
    else
        echo "("${ref#refs/heads/}")"
    fi
}

function proml {
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  local  LIGHT_BLUE="\[\033[1;34m\]"
  local       RESET="\[\033[0;00m\]"
  case $TERM in
    xterm*)
    TITLEBAR="\[\033]0;\u@\h:\w\007\]"
    ;;
    *)
    TITLEBAR=""
    ;;
  esac

PS1="${TITLEBAR}\
$LIGHT_BLUE\w$RESET$RED \$(parse_git_branch)\
$WHITE\$ $RESET"
PS2='> '
PS4='+ '
}
proml
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Thanks for the awesome idea batasrki
function gemdir {
  if [[ -z "$1" ]] ; then
    echo "gemdir expects a parameter, which should be a valid RVM Ruby selector"
  else
    rvm "$1"
    cd $(rvm gemdir)
    pwd
  fi
}

# bash function, usage: $ st -p [projectname] -opt2 -opt3
function st() {
  if [ -n "$1" -a -n "$2" ]; then # if more than one argument
    if [ "$1" = "-p" -o "$1" = "--project" ]; then # if arg1 is -p or --project
      local projectfile="$2"
      [[ $projectfile != *.sublime-project ]] && projectfile="$2.sublime-project" # detect if arg2 already includes the ext
      if [ -e $projectfile ]; then # does project file exist?
        sublime -n --project $projectfile ${*:3} # open project file, in new window, include trailing args
        #echo "project specified, and project file exists, execute: sublime -n --project $projectfile ${*:3}"
      else
        sublime ${*:3} # open sublime but drop -p||--project and project name from args
        #echo "project specified, but project file doesn't exist, execute: sublime ${*:3}"
      fi
    else
      sublime $* # open sublime and pass args as usual
      #echo "project argument not passed, execute: sublime $*"
    fi
  else
    sublime $* # open sublime and pass args as usual
    #echo "only 1 argument passed, execute: sublime $*"
  fi
}
