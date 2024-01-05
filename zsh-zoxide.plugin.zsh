# Copyright (c) 2020 Mikkel Kaysen

# According to the Zsh Plugin Standard:
# http://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0=${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}
0=${${(M)0:#/*}:-$PWD/$0}

# Then ${0:h} to get plugin's directory

if [[ ${zsh_loaded_plugins[-1]} != */zsh-zoxide && -z ${fpath[(r)${0:h}]} ]] {
    fpath+=( "${0:h}" )
}

# Standard hash for plugins, to not pollute the namespace
typeset -gA Plugins
Plugins[ZSH_ZOXIDE_DIR]="${0:h}"

(( ${+commands[zoxide]} )) && () {

  local command=${commands[zoxide]}
  [[ -z $command ]] && return 1

  # generating init file
  local initfile=$1/zoxide-init.zsh
  if [[ ! -e $initfile || $initfile -ot $command ]]; then
    $command init zsh >| $initfile
    zcompile -UR $initfile
  fi

  source $initfile
} ${Plugins[ZSH_ZOXIDE_DIR]}
