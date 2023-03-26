#!/bin/bash

function zupdate() {
  local zutil=/tmp/zzj/zutil.sh
  wget http://192.168.1.5:8008/D%3A/IdeaProjects/Markdown/zutil.sh -O $zutil.tmp
  if [ $(wc -l < $zutil.tmp) -ne 0 ]; then
    set -x
    mv $zutil.tmp ${zutil}
    set +x
  fi
  source ${zutil}
}

function zhelp() {
  date
}

function zfind() {
  date
}

function main() {
  if [[ "$0" == *zutil.sh ]]; then # sh zutil.sh
    local zutil=$(readlink -m $0)
    local profile=/root/.bashrc
    local add_str="[ -f ${zutil} ] && source ${zutil} &>/dev/null ; echo zutil-add >/dev/null"
    [ ! -f ${profile} ] && touch ${profile}
    if grep -q "zutil-add" ${profile}; then
      echo "Replace config to ${profile}"
      sed -i "/zutil-add/c ${add_str}" ${profile}
    else
      echo "Add config to ${profile}"
      echo -e "\n${add_str}" >> ${profile}
    fi
    echo "${add_str}"
  else # source zutil.sh
    alias cdz='cd /tmp/zzj/'
  fi
}

main "$@"
