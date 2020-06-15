alias Pi='pipenv run pip install '
alias Ppu='Pi -U setuptools==33.1.1'
alias Ppu3='Pi -U setuptools==41.0.1'
alias Pp='Pi debug bs4 virtualenv'
alias Pv='R pipenv --two && Ppu && Pp'
alias Pv3='R pipenv --three && Ppu3 && Pp'
alias Pu='R pipenv --rm'
alias Pk='for i in `find . -print | grep "\.py[co]$"`; do rm $i; done'
alias Pa='. $(pipenv --venv)/bin/activate'
alias Pd='deactivate'
alias Pr='pipenv run pip install -r requirements.txt --upgrade'

# go to git root directory
_cdr() {
  current=$PWD
  while [[ ! "${PWD##*/}" =~ "\." ]]
  do
    ..
    [[ "$PWD" == "/" ]] && break
  done
  if [[ "$PWD" == "/" ]]
  then
    cd $current
    gitroot=`git rev-parse --show-toplevel`
    cd ${gitroot/\/home\/rodfersou\/.projects/\/srv}
  fi
}
alias cdr_='declare -f _cdr'
alias cdr='_cdr'

alias cdrr='cdr; ..; cdr'

_cdpp() {
  README='Go to git project directory'
  cdr
  giturl=`git config --get remote.origin.url`
  gitfolder=${${${giturl##*/}%.*}//.//}
  folder=${${PWD##*/}//.//}
  if [ -d "$folder" ]
  then
    cd "$folder"
  elif [ -d "src/$folder" ]
  then
    cd "src/$folder"
  elif [ -d "$gitfolder" ]
  then
    cd "$gitfolder"
  elif [ -d "src/$gitfolder" ]
  then
    cd "src/$gitfolder"
  fi
}
alias cdpp_='declare -f _cdpp'
alias cdpp='_cdpp'

alias cdp_='cdpp_; echo "vim"'
alias cdp='cdpp; vim'

# go to omelette directory
_cdo() {
  cdr
  om1=api/parts/omelette
  om2=parts/packages
  om3=parts/omelette
  if [ -d "$om1" ]
  then
    cd "$om1"
  elif [ -d "$om2" ]
  then
    cd "$om2"
  elif [ -d "$om3" ]
  then
    cd "$om3"
  fi
}
alias cdo_='declare -f _cdo'
alias cdo='_cdo'

alias cds='cd `pipenv run python -c "import pip; print(pip.__path__[0].rstrip(\"\/pip\"))"`'

alias cdh='cd $PWD'
alias cdww='cdr; cd webpack'
alias cdw='cdww; vim'
