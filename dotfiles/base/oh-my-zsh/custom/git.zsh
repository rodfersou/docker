# No arguments: `git status`
# # With arguments: acts like `git`
_g() {
  if [[ $# -gt 0 ]]
  then
    git "$@"
  else
    C git status
  fi
}
alias g_='declare -f _g'
alias g='_g'
# setopt COMPLETE_ALIASES
# compdef _git g=git

_gsa() {
  for i in *
  do
    echo $i
    cd $i
    git status
    ..
    echo
  done
}
alias gsa_='declare -f _gsa'
alias gsa='_gsa'

_greload() {
  git fetch
  git reset --hard origin/$(git symbolic-ref HEAD | sed -e "s,refs/heads/\(.*\),\1,")
}
alias greload_='declare -f _greload'
alias greload='_greload'
