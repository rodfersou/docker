alias -g Py='--py'
alias -g Js='--js'
alias -g Css='--css'
alias -g Less='-G "\.less$"'
alias -g Sass='-G "\.sass$"'
alias -g Xml='--xml'
alias -g Pt='-G "\.pt$"'
alias -g Cfg='-G "\.cfg$"'
alias -g Zcml='-G "\.zcml$"'
alias -g Rf='-G "\.robot$"'

_ag() {
  dir=`pwd`
  (cd / && DIRENV_LOG_FORMAT="" ag -f --nogroup --pager="less -XFR" $@ $dir)
}
alias ag_='declare -f _ag'
alias ag='_ag'
