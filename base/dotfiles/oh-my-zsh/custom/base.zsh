alias -g X='> /dev/null 2> /dev/null &'
alias -g R='reset;'
alias -g C='clear;'
alias -g L='2>&1 | less'

alias reload='R source ~/.zshrc'
alias F='find -L . -print | grep '
alias Rl='\R'

_K() {
  if [[ $# -gt 0 ]]; then
    ps -ax | egrep -i $1 | grep -v grep | awk '{print "kill -9 " $1}' | sh
  else
    echo "Usage: K <program>"
  fi
}
alias K_='declare -f _cdo'
alias K='_K'
alias Kp='K interpreter'
