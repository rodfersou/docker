ZSH_THEME="agnoster"
DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
plugins=(
  git wd globalias asdf
)

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

bindkey "^R" history-incremental-search-backward

bindkey -M emacs " " magic-space
bindkey -M viins " " magic-space
bindkey -M emacs "^E" globalias
bindkey -M viins "^E" globalias
bindkey -s "^\\" "fg\n"
