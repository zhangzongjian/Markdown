#!/bin/bash

function zupdate() {
  wget http://192.168.1.5:8008/D%3A/IdeaProjects/Markdown/zutil.sh -O $zutil.tmp
  if [ $(wc -l < $zutil.tmp) -ne 0 ]; then
    set -x
    mv $zutil.tmp ${zutil}
    set +x
  fi
  source ${zutil}
}

function zget() {
  if [ $# == 0 ]; then
    echo 'zget "win_file_path" target_path target_path   # 下载到多个目标'
    echo 'zget target_path                               # 从默认win路径下载到目标'
    echo 'zget "win_file_path"                           # 下载到当前目录'
    return
  fi
  local default_path="D:\\ftp"
  if [[ ! "$1" =~ "\\" ]] && [[ ! "$1" =~ "/"  ]]; then  # 仅文件名
    local file_path=$(echo "${default_path}\\$1" | sed 's#\\#/#g')
  elif [[ "$1" =~ "\\" ]];then  # win_path
    local file_path=$(echo "$1" | sed 's#\\#/#g' | sed 's/ /%20/g' | sed 's/%/%25/g')
  fi
  local file_name=$(echo "$file_path" | sed 's#.*/##' | sed 's/%20/ /g' | sed 's/%25/%/g')
  if [ $# -gt 1 ]; then  # zget win_file_path target_path
    shift
    for target in "$@"; do
      [ -d "${target}" ] && target="${target}/${file_name}"
      wget http://192.168.1.5:8008/${file_path} -O "${target}"
    done
  elif [[ "$1" =~ ^/ ]];then  # zget target_path
    zget $(basename $1) $1
  else  # zget win_file_path
    wget http://192.168.1.5:8008/${file_path} -O "${file_name}"
  fi
}

function zdownload() {
  date
}

function zhelp() {
  local fun_name=$1
  local fun_line
  local remark
  local blank_str="                                "
  grep "^function " ${zutil} | while read -r fun_line; do
    [ -n "${fun_name}" ] && [[ ! "${fun_line}" =~ "${fun_name}" ]] && continue
    echo "-------------------------------------"
    remark=""
    local line_num=$(grep -n "^${fun_line}$" ${zutil} | awk -F':' '{print $1}')
    for ((line_num = line_num - 1; line_num > 0; line_num--)); do
      local line_str=$(sed -n "${line_num} p" ${zutil})
      if [ $(expr index "${line_str}" "#") -eq 1 ]; then
        remark=$(echo -e "${remark}\n${blank_str}${line_str}")
      else
        fun_line=$(echo ${fun_line} | awk '{print $2}' | sed 's/()//g')
        echo ${fun_line}"$(echo "${remark}" | tac)" | sed "1 s/${blank_str}/${blank_str:${#fun_line}}/g" | sed "s/ #/ /g"
        break
      fi
    done
  done
  echo "-------------------------------------"
}

function zfind() {
  if [[ $# -gt 1 && $2 != -* ]]; then
    local name=$1
    local grep_str=$2
    shift 2
    local cmd="find $(pwd) -name \"$name\" | xargs grep --color -n \"${grep_str}\" $@"
    echo "$cmd"
    eval "$cmd"
    return
  fi
  if [[ $# -gt 0 && $1 != -* ]]; then
    local name=$1
    shift
    local ext=$@
    local is_cd=false
    [[ "${ext}" =~ "-ls" ]] && ext=${ext//"-ls"/}" -exec ls -lh {} +"
    [[ "${ext}" =~ "-cd" ]] && ext=${ext//"-cd"/"-type d"} && is_cd=true
    local cmd="find $(pwd) -name \"$name\" $ext"
    echo "$cmd"
    local result=$(eval "$cmd")
    [ -n "${result}" ] && echo "${result}"
    r=$(echo "${result}" | tail -1)
    [ -n "${r}" ] && [ "${is_cd}" == "true" ] && cd ${r}
    return
  fi
  find $(pwd) "$@"
}

function zmain() {
  if [[ "$0" =~ "zutil.sh" ]]; then # sh zutil.sh
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
    zutil=$(readlink -m ${BASH_SOURCE[0]})
    alias cdz='cd /tmp/zzj/'
    complete -W "$(cat ${zutil} | grep "^function [^()]*" -Eo | awk '{print $2}' | xargs)" zhelp
  fi
}

zmain "$@"
