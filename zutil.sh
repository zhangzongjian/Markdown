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
  if [ "$0" == "zutil.sh" ]; then # sh zutil.sh
    local zutil=$(readlink -m $0)
    local profile=/root/.bashrc
    local add_str="[ -f ${zutil} ] && source ${zutil} &>/dev/null ; echo zutil-add >/dev/null"
    if grep -q "zutil-add" ${profile}; then
      sed -i "/zutil-add/c ${add_str}" ${profile}
    else
      echo -e "\n${add_str}" >> ${profile}
    fi
  else # source zutil.sh
    echo "source zutil.sh" > /dev/null
  fi
}

main "$@"
